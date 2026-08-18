// const note = require("../models/notes.model");
// const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
// const Note = require('../models/notes.model');
// const User = require("../models/user.model");

// //userId is the Mongoose ObjectId of the user who created the note
// const createNote = async(userId, title, subject, college, semester, branch, fileBuffer) =>{
//     const result = await uploadToCloudinary(fileBuffer);
//     //adding the note to the database
//     const note = await Note.create({    
//         userId: userId,
//         title: title,
//         subject: subject,
//         college: college,
//         semester: semester,
//         branch: branch,
//         cloudinaryUrl: result.cloudinary_url,
//         cloudinaryPublicId: result.cloudinary_public_id
//     });
//     await User.findOneAndUpdate({_id: userId}, {$inc: {totalNotes: 1}});
//     return note;
// };

// const PAGE_SIZE = 10; 
// const getNotes = async(
//     cursor,
//     subject,
//     college,
//     branch,
//     semester,
//     userId,
//     search,
//     sort = "latest"
// ) => {
//     const filter = {};
//     if(college) filter.college = college;
//     if(subject) filter.subject = subject;
//     if(branch) filter.branch = branch;
//     if(semester) filter.semester = semester;
//     if(userId) filter.userId = userId;

//     if(search){
//         filter.$or = [
//             {title: {$regex: `^${search}`, $options: "i"}},
//             {subject: {$regex: `^${search}`, $options: "i"}},
//             {college: {$regex: `^${search}`, $options: "i"}}
//         ]
//     }
//     const sortOptions = {
//         latest: {createdAt: -1},
//         oldest: {createdAt: 1},
//         mostLiked: {likeCount: -1},
//         mostDownloaded: {downloadCount: -1},
//         highestRated: {avgRating: -1}
//     };
//     if(cursor && sort === "latest"){
//         filter._id = {$lt: cursor};
//     }

//     const notes = await Note.find(filter)
//         .sort(sortOptions[sort] || sortOptions.latest)
//         .limit(PAGE_SIZE + 1); // PAGE_SIZE notes + 1 extra to check if there are more notes
//         // .populate("creatorId", "name email photoUrl");
//     let hasMore = false;
//     let nextCursor = null;
//     if(notes.length > PAGE_SIZE){
//         hasMore = true;
//         notes.pop(); // remove the extra note
//         nextCursor = notes[notes.length - 1]._id;
//     }

//     return {notes, hasMore, nextCursor};
// };

// const getMyNotes = async(userId, cursor) =>{
//     const filter = {userId};
//     const totalNotes = await Note.countDocuments(filter);
//     if(cursor){
//         filter._id = {$lt: cursor};
//     }
//     const notes = await Note.find(filter)
//     .sort({_id: -1})
//     .limit(PAGE_SIZE + 1); // PAGE_SIZE notes + 1 extra to check if there are more notes

//     let hasMore = false;
//     let nextCursor = null;
//     if(notes.length > PAGE_SIZE){
//         hasMore = true;
//         notes.pop(); // remove the extra note
//         nextCursor = notes[notes.length - 1]._id;
//     }

//     return {notes, hasMore, nextCursor, totalNotes};
// }

// const getNoteById = async(noteId) => {
//     const note = await Note.findById(noteId);
//     return note;
// };

// const updateNote = async(noteId, creatorId, updateData) => {
//     const note = await Note.findById(noteId);
//     if(!note){
//         return null;
//     }
//     if(note.userId !== creatorId){
//         return null;
//     }
//     //Copies updateData properties to note object and saves it to the database
//     //We cant do, note = updateData, because that will create a new object and we will lose the reference to the original note object
//     Object.assign(note, updateData);
//     await note.save();
//     return note;
// }

// const deleteNote = async(noteId, creatorId) => {
//     const note = await Note.findById(noteId);
//     if(!note){
//         return null;
//     }
//     if(note.userId !== creatorId){
//         return null;
//     }
//     //Delete the note from cloudinary
//     await deletePdf(note.cloudinaryPublicId);
//     //Delete the note from the database
//     await note.remove();
//     await User.findOneAndUpdate({_id: creatorId}, {$inc: {totalNotes: -1}});
//     return note;
// }

// module.exports = { createNote, getNotes, getMyNotes, getNoteById, updateNote, deleteNote };

const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
const Note = require("../models/notes.model");
const User = require("../models/user.model");

const PAGE_SIZE = 10;

// ==================== CREATE NOTE ====================

const createNote = async (
    userId,
    title,
    subject,
    college,
    semester,
    branch,
    fileBuffer
) => {
    const result = await uploadToCloudinary(fileBuffer);
    const note = await Note.create({
        userId,
        title,
        subject,
        college,
        semester,
        branch,
        cloudinaryUrl: result.cloudinary_url,
        cloudinaryPublicId: result.cloudinary_public_id,
        pageCount: result.pageCount
    });
    await User.findByIdAndUpdate(userId, {$inc: {totalNotes: 1}});
    return note;
};

// ==================== LIST NOTES ====================

const getNotes = async (
    cursor,
    subject,
    college,
    branch,
    semester,
    userId,
    search,
    sort = "latest"
) => {
    const filter = {};
    if (college) filter.college = college;
    if (subject) filter.subject = subject;
    if (branch) filter.branch = branch;
    if (semester) filter.semester = semester;
    if (userId) filter.userId = userId;
    if (search) {
        filter.$or = [
            {title: {$regex: `^${search}`,$options: "i"}},
            {subject: {$regex: `^${search}`,$options: "i"}},
            {college: {$regex: `^${search}`,$options: "i"}}
        ];
    }
    const sortOptions = {
        latest: { createdAt: -1 },
        oldest: { createdAt: 1 },
        mostLiked: { likeCount: -1 },
        mostDownloaded: { downloadCount: -1 },
        highestRated: { avgRating: -1 }
    };
    const totalNotes = await Note.countDocuments(filter);

    if (cursor && sort === "latest") {
        filter._id = {$lt: cursor};
    }
    
    const notes = await Note.find(filter)
        .populate(
            "userId",
            "name photoUrl college branch semester isVerified totalNotes"
        )
        .sort(sortOptions[sort] || sortOptions.latest)
        .limit(PAGE_SIZE + 1);

    let hasMore = false;
    let nextCursor = null;
    if (notes.length > PAGE_SIZE) {
        hasMore = true;
        notes.pop();
        nextCursor = notes[notes.length - 1]._id;
    }
    return {
        notes,
        hasMore,
        nextCursor,
        totalNotes
    };
};

// ==================== MY NOTES ====================

const getMyNotes = async (userId, cursor) => {
    const filter = {userId};
    const totalNotes = await Note.countDocuments(filter);
    if (cursor) {
        filter._id = {$lt: cursor};
    }
    const notes = await Note.find(filter)
        .populate(
            "userId",
            "name photoUrl college branch semester isVerified totalNotes"
        )
        .sort({_id: -1})
        .limit(PAGE_SIZE + 1);

    let hasMore = false;
    let nextCursor = null;
    if (notes.length > PAGE_SIZE) {
        hasMore = true;
        notes.pop();
        nextCursor = notes[notes.length - 1]._id;
    }
    return {
        notes,
        hasMore,
        nextCursor,
        totalNotes
    };
};

// ==================== GET NOTE ====================

const getNoteById = async (noteId) => {
    return await Note.findById(noteId)
        .populate(
            "userId",
            "name photoUrl college branch semester isVerified"
        );
};

// ==================== DOWNLOAD NOTE ====================

const downloadNote = async(noteId)=>{
    const note = await Note.findByIdAndUpdate(noteId, {$inc: {downloadCount: 1}}, {new: true});
    if(!note){
        return null;
    }
    let downloadUrl = note.cloudinaryUrl;
    if(downloadUrl.includes("res.cloudinary.com") && !downloadUrl.includes('fl_attachment')){
        downloadUrl = downloadUrl.replace('/upload/', '/upload/fl_attachment/');
    }
    return { 
        note, 
        downloadUrl
    }
}

// ==================== UPDATE NOTE ====================

const updateNote = async (noteId, userId, updateData) => {
    const note = await Note.findOne({_id: noteId, userId});
    if (!note) {
        return null;
    }
    Object.assign(note, updateData);
    await note.save();
    return note;
};

// ==================== DELETE NOTE ====================

const deleteNote = async (noteId, userId) => {
    const note = await Note.findOne({
        _id: noteId,
        userId
    });
    if (!note) {
        return null;
    }
    await deletePdf(note.cloudinaryPublicId);
    await note.deleteOne();
    await User.findByIdAndUpdate(userId, {$inc: {totalNotes: -1}});
    return note;
};

module.exports = {
    createNote,
    getNotes,
    getMyNotes,
    getNoteById,
    updateNote,
    deleteNote,
    downloadNote
};