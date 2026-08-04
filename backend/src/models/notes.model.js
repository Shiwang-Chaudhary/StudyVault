const mongoose = require("mongoose");

const noteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    title: {
      type: String,
      required: true,
      trim: true,
    },

    subject: {
      type: String,
      required: true,
      trim: true,
    },

    branch: {
      type: String,
      trim: true,
    },

    semester: {
      type: String,
      trim: true,
    },

    college: {
      type: String,
      required: true,
      trim: true,
    },

    cloudinaryUrl: {
      type: String,
      required: true,
    },

    cloudinaryPublicId: {
      type: String,
      required: true,
    },

    likeCount: {
      type: Number,
      default: 0,
      min: 0,
    },

    downloadCount: {
      type: Number,
      default: 0,
      min: 0,
    },

    avgRating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },

    ratingCount: {
      type: Number,
      default: 0,
      min: 0,
    },
  },
  {
    timestamps: true,
  }
);

// ---------- Indexes ----------

// My Notes
noteSchema.index({ creatorId: 1 });

// Search
noteSchema.index({ title: 1 });
noteSchema.index({ subject: 1 });
noteSchema.index({ college: 1 });

// Filters
noteSchema.index({ branch: 1 });
noteSchema.index({ semester: 1 });

// Sorting
noteSchema.index({ createdAt: -1 });
noteSchema.index({ likeCount: -1 });
noteSchema.index({ downloadCount: -1 });
noteSchema.index({ avgRating: -1 });

module.exports = mongoose.model("Note", noteSchema);