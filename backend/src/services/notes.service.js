const asyncHandler = require("express-async-handler");
const note = require("../models/notes.model");
const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
const Note = require('../models/notes.model');
const User = require("../models/user.model");

//createrId is firebaseUid of the user who created the note
const createNote = async(createrId, title, subject, college, semester, branch, fileBuffer) =>{
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
    
};

const getNotes = async(
    cursor,
    subject,
    college,
    branch,
    semester,
    creatorId,
    search,
    sort = "latest"
) => {
    const filter = {};
    if(college) filter.college = college;
    if(subject) filter.subject = subject;
    if(branch) filter.branch = branch;
    if(semester) filter.semester = semester;
    if(creatorId) filter.creatorId = creatorId;

    if(search){
        filter.$or = [
            {title: {$regex: search, $options: "i"}},
            {subject: {$regex: search, $options: "i"}},
            {college: {$regex: search, $options: "i"}}
        ]
    }
    const sortOptions = {
        latest: {createdAt: -1},
        oldest: {createdAt: 1},
        mostLiked: {likeCount: -1},
        mostDownloaded: {downloadCount: -1},
        highestRated: {avgRating: -1}
    };
    if(cursor && sort === "latest"){
        filter._id = {$lt: cursor};
    }

    const notes = await Note.find(filter)
        .sort(sortOptions[sort] || sortOptions.latest)
        .limit(20+1) // 20 notes + 1 extra to check if there are more notes
        .populate("creatorId", "name email photoUrl");
    let hasMore = false;
    let nextCursor = null;
    if(notes.length > 20){
        hasMore = true;
        notes.pop(); // remove the extra note
        nextCursor = notes[notes.length - 1]._id;
    }

    return {notes, hasMore, nextCursor};
};

module.exports = { createNote, getNotes };