const asyncHandler = require("express-async-handler");
const Note = require("../models/notes.model");
const { ApiError, successResponse } = require("../utils/apiResponse.utils");
const noteService = require("../services/notes.service");

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
    const note = await noteService.createNote(firebaseUserid, title, subject, college, semester, branch, uploadedFile.buffer);
    return successResponse(res, 201, note);

});

const listNotes = asyncHandler(async(req,res) => {
    const {cursor, subject, college, branch, semester, search, sort} = req.query;
    const creatorId = req.user ? req.user.uid : null;
    // const creatorId = "BzUUY9AHmIgqDRMI2AuZ0K6NV7J2";
    const notes = await noteService.getNotes(cursor, subject, college, branch, semester, creatorId, search, sort);
    return successResponse(res, 200, notes);
});

const getMyNotes = asyncHandler(async(req,res) => {
    const {cursor} = req.query;
    const creatorId = req.user.uid;
    // const creatorId = "PM5hByxxJAdgAWrxiBKiJr5SXD42";
    const notes = await noteService.getMyNotes(creatorId, cursor);
    return successResponse(res, 200, notes);
});

const getNoteById = asyncHandler(async(req,res) => {
    const noteId = req.params.id;
    const note = await noteService.getNoteById(noteId);
    if(!note){
        throw new ApiError(404, "Note not found");
    }
    return successResponse(res, 200, note);
});

const updateNote = asyncHandler(async(req,res) =>{
    const noteId = req.params.id;
    const creatorId = req.user.uid;
    const note = await noteService.updateNote(noteId, creatorId, req.body);
    if(!note){
        throw new ApiError(404, "Note not found");
    }
    if(note.creatorId !== creatorId){
        throw new ApiError(403, "You are not authorized to update this note");
    }
    return successResponse(res, 200, note);
});

const deleteNote = asyncHandler(async(req,res) =>{
    const noteId = req.params.id;
    const creatorId = req.user.uid;
    const note = await noteService.deleteNote(noteId, creatorId);
    if(!note){
        throw new ApiError(404, "Note not found");
    }
    if(note.creatorId !== creatorId){
        throw new ApiError(403, "You are not authorized to delete this note");
    }
    return successResponse(res, 200, {message: "Note deleted successfully"});
    });

module.exports = { uploadNote, listNotes, getMyNotes, getNoteById, updateNote, deleteNote };