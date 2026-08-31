const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
const Note = require("../models/notes.model");
const User = require("../models/user.model");
const Bookmark = require("../models/bookmark.model");
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
        .populate("userId")
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
        .populate("userId")
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
        .populate("userId");
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

// ==================== BOOKMARK NOTE ====================

const bookmarkNote = async(noteId, userId) => {
    if(!noteId || !userId) return null;
    const bookmark = await Bookmark.create({
        user: userId,   
        note: noteId
    });
    return bookmark;
}

const getBookmarks = async(userId) => {
    const bookmarks = await Bookmark.find({user: userId}).populate({
        path: "note",
        populate: {
            path: "userId",
        },
    });
    if(!bookmarks || bookmarks.length === 0){
        return [];
    }
    return bookmarks;
}

const deleteBookmark = async(noteId, userId) => {
    const bookmark = await Bookmark.findOneAndDelete(
        {
            note: noteId,
            user: userId
        }
    );
    return bookmark;
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
    downloadNote,
    bookmarkNote,
    deleteBookmark,
    getBookmarks
};