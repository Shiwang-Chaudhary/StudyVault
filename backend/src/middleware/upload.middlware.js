const multer = require('multer');
const {ApiError} = require('../utils/apiResponse.utils');

//Using memorystorage because we want to upload the file to cloudinary directly without saving it to the server
const storage = multer.memoryStorage();
const fileFilter = (req, file, cb) => {
    if(file.mimetype === 'application/pdf'){
        //cb(error, acceptFile)
        cb(null, true);
    } else {
        cb(new ApiError(400, 'Only PDF files are allowed!'), false);
    }
};

const upload = multer({
    storage: storage,
    fileFilter: fileFilter,
    limits: {fileSize: 10 * 1024 * 1024} //10MB
});

module.exports = upload;