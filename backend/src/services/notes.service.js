const asyncHandler = require("express-async-handler");
const note = require("../models/notes.model");
const cloudinary = require("../config/cloudinary.config");
const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
const Note = require('../models/notes.model');

//createrId is firebaseUid of the user who created the note
const createNote = asyncHandler(async(createrId, title, subject, college, fileBuffer) =>{
    const result = await uploadToCloudinary(fileBuffer);

    //adding the note to the database
    const note = await Note.create({    
        creatorId: createrId,
        title: title,
        subject: subject,
        college: college,
        cloudinaryUrl: result.cloudinary_url,
        cloudinaryPublicId: result.cloudinary_public_id
    });
    return note;
});

module.exports = { createNote };