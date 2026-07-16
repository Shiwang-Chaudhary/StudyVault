const expressAsyncHandler = require("express-async-handler");
const note = require("../models/notes.model");

//createrId is firebaseUid of the user who created the note
const createNote = expressAsyncHandler(async(createrId, title, subject, college, fileBuffer) =>{});