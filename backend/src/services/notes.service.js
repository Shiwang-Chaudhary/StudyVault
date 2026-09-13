const { uploadToCloudinary, deletePdf } = require("../services/cloudinary_upload.service");
const Note = require("../models/notes.model");
const User = require("../models/user.model");
const Bookmark = require("../models/bookmark.model");
const Rating = require("../models/rating.model");
const PAGE_SIZE = 10;
const mongoose = require("mongoose");

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
// ==================== RATE NOTE ====================

const rateNote = async(noteId, userId, value) => {
    const note = await Note.findById(noteId);
    if(!note){
        return null;
    }
    if (note.userId.equals(userId)) {
        return null;
    }
    await Rating.findOneAndUpdate(
        {note: noteId, user: userId},
        {value},
        {upsert: true, new: true, setDefaultsOnInsert: true}
    );

    const stats = await Rating.aggregate([
        {$match: {note: new mongoose.Types.ObjectId(noteId)}},
        {
            $group: {
                _id : "$note",
                avgRating: {$avg: "$value"},
                ratingCount: {$sum: 1}
            }
        }
    ]);
    //stats returns an array with one object containing avgRating and ratingCount
    const {avgRating = 0, ratingCount = 0} = stats[0] ?? {};
    note.avgRating = Math.round(avgRating * 10) / 10; // round to 1 decimal place
    note.ratingCount = ratingCount;
    await note.save();

    //Update user totalRatings and avgRating
    const ownerId = note.userId;
    const userStats = await Note.aggregate([
        {$match: {userId: new mongoose.Types.ObjectId(ownerId)}},
        {
            $group:{
                _id: null,
                totalRatingValue: {
                    $sum: {
                        $multiply: ['$avgRating', '$ratingCount']
                    }
                },
                totalCountValue: {
                    $sum: '$ratingCount'
                }
            }
        }
    ])
    const {totalRatingValue = 0, totalCountValue = 0} = userStats[0] ?? {};
    const userAvgRating = totalCountValue > 0 ? totalRatingValue/totalCountValue : 0;
    const updatedUser = await User.findByIdAndUpdate(
        {_id: ownerId},
        {avgRating: userAvgRating},
        {new: true}
    );
    return note;
}

const getNoteRatings = async(noteId, cursor)=> {
    const filters = {note: noteId};
    const note = await Note.findById(noteId)
        .select("avgRating ratingCount");    
        if(cursor){
            filters._id = {
                $lt: cursor
            };
        }
    const ratings = await Rating.find(filters)
                    .populate("user", "name profilePic")
                    .sort({_id: -1})
                    .limit(PAGE_SIZE + 1);
    let hasMore = false;
    let nextCursor = null;
    if(ratings.length > PAGE_SIZE){
        hasMore = true;
        ratings.pop();
        nextCursor = ratings[ratings.length - 1]._id;
    }
    return {
        avgRating: note.avgRating, ratingCount: note.ratingCount,  ratings, hasMore, nextCursor};
}

    const deleteRating = async(noteId, userId) => {
        const rating = await Rating.findOneAndDelete({note: noteId, user: userId});
        if(!rating){
            return null;
        }
        const stats = await Rating.aggregate([
            {$match: {note: new mongoose.Types.ObjectId(noteId)}},
            {
                $group: {
                    _id : "$note",
                    avgRating: {$avg: "$value"},
                    ratingCount: {$sum: 1}
                }
            }
        ]);
        const note = await Note.findById(noteId);
        if(stats.length > 0){
            const {avgRating = 0, ratingCount = 0} = stats[0];
            note.avgRating = Math.round(avgRating * 10) / 10; // round to 1 decimal place
            note.ratingCount = ratingCount;
        } else {
            note.avgRating = 0;
            note.ratingCount = 0;
        }
        await note.save();
        return rating;
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
    getBookmarks,
    rateNote,
    getNoteRatings
};