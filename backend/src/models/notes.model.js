const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema(
  {
    creatorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    //   index: true,
    },
    title: {
      type: String,
      required: true,
    //   trim: true,
    },
    description: {
      type: String,
      trim: true,
      default: '',
    },
    subject: {
      type: String,
      required: true,
      trim: true,
    //   index: true,
    },
    college: {
      type: String,
      required: true,
      trim: true,
    //   index: true,
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
    },
    downloadCount: {
      type: Number,
      default: 0,
    },
    avgRating: {
      type: Number,
      default: 0,
    },
    ratingCount: {
      type: Number,
      default: 0,
    },
  },
  { timestamps: true }
);

// Text index for basic search across title/subject/college
// noteSchema.index({ title: 'text', subject: 'text', college: 'text' });

module.exports = mongoose.model('Note', noteSchema);
