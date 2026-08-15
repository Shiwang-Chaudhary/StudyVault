const asyncHandler = require("express-async-handler");
const Note = require("../models/notes.model");
const { ApiError, successResponse } = require("../utils/apiResponse.utils");
const noteService = require("../services/notes.service");

const uploadNote = asyncHandler(async(req,res)=>{

    const userId = req.user._id;
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
    const note = await noteService.createNote(userId, title, subject, college, semester, branch, uploadedFile.buffer);
    return successResponse(res, 201, note);

});

const listNotes = asyncHandler(async(req,res) => {
    //I have to remove creatorId from query params 
    const {cursor, subject, college, branch, semester, search, sort, userId} = req.query;
    // const creatorId = req.user ? req.user.uid : null;
    // const creatorId = "BzUUY9AHmIgqDRMI2AuZ0K6NV7J2";
    const notes = await noteService.getNotes(cursor, subject, college, branch, semester, userId, search, sort);
    return successResponse(res, 200, notes);
});

const getMyNotes = asyncHandler(async(req,res) => {
    const {cursor} = req.query;
    // const userId = req.user._id;
    const userId = "6a6ef0ada2d4366d71437583";
    const notes = await noteService.getMyNotes(userId, cursor);
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

const downloadNote = asyncHandler(async(req,res) => {
    const noteId = req.params.id;
    const {note, downloadUrl} = await noteService.downloadNote(noteId);
     if(!note){
        throw new ApiError(404, "Note not found");
    }
    return successResponse(res, 200, {downloadCount: note.downloadCount, downloadUrl});
});

const updateNote = asyncHandler(async(req,res) =>{
    const noteId = req.params.id;
    const userId = req.user._id;
    const note = await noteService.updateNote(noteId, userId, req.body);
    if(!note){
        throw new ApiError(404, "Note not found");
    }
    if(note.userId !== userId){
        throw new ApiError(403, "You are not authorized to update this note");
    }
    return successResponse(res, 200, note);
});

const deleteNote = asyncHandler(async(req,res) =>{
    const noteId = req.params.id;
    const userId = req.user._id;
    const note = await noteService.deleteNote(noteId, userId);
    if(!note){
        throw new ApiError(404, "Note not found");
    }
    if(note.userId !== userId){
        throw new ApiError(403, "You are not authorized to delete this note");
    }
    return successResponse(res, 200, {message: "Note deleted successfully"});
    });

module.exports = { uploadNote, listNotes, getMyNotes, getNoteById, updateNote, deleteNote, downloadNote };