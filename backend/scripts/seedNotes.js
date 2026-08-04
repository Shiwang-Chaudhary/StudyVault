const mongoose = require("mongoose");
const Note = require("../src/models/notes.model");
const User = require("../src/models/user.model");

mongoose.connect(
  "mongodb://aditya:9555375817@192.168.1.100:27017/StudyVault?authSource=admin"
);

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function seed() {
  const firebaseUid = "PM5hByxxJAdgAWrxiBKiJr5SXD42";

  // Find the MongoDB user
  const user = await User.findOne({ firebaseUid });

  if (!user) {
    throw new Error("User not found");
  }

  for (let i = 1; i <= 50; i++) {
    await Note.create({
      userId: user._id,
      title: `Test Note ${i}`,
      subject: "Operating Systems",
      branch: "CSE",
      semester: "Semester IV",
      college: "Gurugram University",
      cloudinaryUrl: "https://dummy-url.com/file.pdf",
      cloudinaryPublicId: "dummy-public-id",
    });

    console.log(`Inserted Test Note ${i}`);

    if (i < 50) {
      await sleep(1000);
    }
  }

  const totalNotes = await Note.countDocuments({
    userId: user._id,
  });

  await User.findByIdAndUpdate(user._id, {
    totalNotes,
  });

  console.log("50 notes inserted!");

  process.exit();
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});