const cloudinary = require('../config/cloudinary.config');
const { Readable } = require('stream');

const uploadToCloudinary = async (fileBuffer, folder = 'studyVault/notes') => {
    return new Promise((resolve, reject) =>{
        const uploadStream = cloudinary.uploader.upload_stream(
            {
                folder,
                resource_type: 'image',
                format: 'pdf',
                pages: true,
            },
            (error, result) => {
                if (error) {
                    console.error("Cloudinary Error:");
                    console.error(error);
                    console.error("Message:", error.message);
                    console.error("HTTP Code:", error.http_code);
                    return reject(error);
                } else {
                    resolve({
                        cloudinary_url: result.secure_url,
                        cloudinary_public_id: result.public_id,
                        pageCount: result.pages || 1,
                    });
                }
            }
        );
        //We need to convert the file buffer into a readable stream and pipe it to the upload stream because cloudinary needs redable stream to upload the file
        Readable.from(fileBuffer).pipe(uploadStream);

    });
}

const deletePdf = (publicId) => {
  return cloudinary.uploader.destroy(publicId, { resource_type: 'raw' });
};

module.exports = { uploadToCloudinary, deletePdf };
