const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    firebaseUid: {
      type: String,
      required: true,
      unique: true, // one MongoDB doc per Firebase user
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
    },
    photoUrl: {
      type: String,
      default: null,
    },

    // Onboarding fields — null until user completes OnboardingScreen
    // Flutter checks: if college == null → show onboarding, else → home
    college: { type: String, default: null },
    branch: { type: String, default: null },
    semester: { type: String, default: null },
    subjects: { type: [String], default: [] }, // subject preferences from step 2

    // V2 fields — store now so schema doesn't need migration later
    walletBalance: { type: Number, default: 0 },
    earnings: { type: Number, default: 0 },

    // Computed stats — updated whenever a note is uploaded/deleted
    totalNotes: { type: Number, default: 0 },
    totalBookmarks: { type: Number, default: 0 },
    avgRating: { type: Number, default: 0 },
    isVerified: { type: Boolean, default: false },
  },
  {
    timestamps: true, // adds createdAt and updatedAt automatically
  }
);

module.exports = mongoose.model("User", userSchema);