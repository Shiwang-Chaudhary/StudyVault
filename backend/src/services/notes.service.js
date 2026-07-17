const asyncHandler = require("express-async-handler");
const note = require("../models/notes.model");
const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
const Note = require('../models/notes.model');
const User = require("../models/user.model");

//createrId is firebaseUid of the user who created the note
const createNote = asyncHandler(async(createrId, title, subject, college, semester, branch, fileBuffer) =>{
    try{
        const result = await uploadToCloudinary(fileBuffer);

    //adding the note to the database
    const note = await Note.create({    
        creatorId: createrId,
        title: title,
        subject: subject,
        college: college,
        semester: semester,
        branch: branch,
        cloudinaryUrl: result.cloudinary_url,
        cloudinaryPublicId: result.cloudinary_public_id
    });
    await User.findOneAndUpdate({firebaseUid: createrId}, {$inc: {totalNotes: 1}});
    return note;
    }catch(err){
        throw new Error("Error uploading note to cloudinary: " + err.message);
    }
    
});

module.exports = { createNote };