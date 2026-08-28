const mongoose = require("mongoose");

const bookmarkSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    note: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Note",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

// A user can bookmark a note only once
bookmarkSchema.index({ user: 1, note: 1 }, { unique: true });

module.exports = mongoose.model("Bookmark", bookmarkSchema);