const asyncHandler = require("express-async-handler");
const Note = require("../models/notes.model");
const { ApiError, successResponse } = require("../utils/apiResponse.utils");
const { createNote } = require("../services/notes.service");

const uploadNote = asyncHandler(async(req,res)=>{
    const firebaseUserid = req.user.uid;
    const {title, subject, college} = req.body;
    const uploadedFile = req.file;

    if(!uploadedFile){
        throw new ApiError(400, "No file uploaded");
    }

    if(!title || !subject || !college){
        throw new ApiError(400, "Title, subject and college are required");
    }

    //Upload the file to cloudinary
    const note = await createNote(firebaseUserid, title, subject, college, uploadedFile.buffer);
    return successResponse(res, 201, note);

});

module.exports = { uploadNote };