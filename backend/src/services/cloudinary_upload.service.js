const cloudinary = require('../config/cloudinary.config');
const streamfier = require('streamifier');

const uploadToCloudinary = async (fileBuffer, folder = 'studyValut/notes') => {
    return Promise((resolve, reject) =>{
        const uploadStream = cloudinary.uploader.upload_stream(
            {
                folder,
                resource_type: 'raw',
            },
            (error, result) => {
                if (error) {
                    reject(error);
                } else {
                    resolve({
                        cloudinary_url: result.secure_url,
                        cloudinary_public_id: result.public_id,
                    });
                }
            }
        );
        //We need to convert the file buffer into a readable stream and pipe it to the upload stream because cloudinary needs redable stream to upload the file
        streamfier.createReadStream(fileBuffer).pipe(uploadStream);

    });
}

const deletePdf = (publicId) => {
  return cloudinary.uploader.destroy(publicId, { resource_type: 'raw' });
};

module.exports = { uploadToCloudinary, deletePdf };
