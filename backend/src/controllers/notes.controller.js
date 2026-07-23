const asyncHandler = require("express-async-handler");
const Note = require("../models/notes.model");
const { ApiError, successResponse } = require("../utils/apiResponse.utils");
const { createNote, getNotes } = require("../services/notes.service");

const uploadNote = asyncHandler(async(req,res)=>{

    const firebaseUserid = req.user.uid;
    const {title, subject, college, semester, branch} = req.body;
    console.log("Body:", req.body);
    console.log("File:", req.file);
    const uploadedFile = req.file;

    if(!uploadedFile){
        throw new ApiError(400, "No file uploaded");
    }

    if(!title || !subject || !college || !semester || !branch){
        throw new ApiError(400, "Title, subject, college, semester and branch are required");
    }
    
    //Upload the file to cloudinary
    const note = await createNote(firebaseUserid, title, subject, college, semester, branch, uploadedFile.buffer);
    return successResponse(res, 201, note);

});

const listNotes = asyncHandler(async(req,res) => {
    const {cursor, subject, college, branch, semester, search, sort} = req.query;
    const creatorId = req.user ? req.user.uid : null;
    const notes = await getNotes(cursor, subject, college, branch, semester, creatorId, search, sort);
    return successResponse(res, 200, notes);
});

module.exports = { uploadNote, listNotes };