const mongoose = require("mongoose");
const Note = require("../src/models/notes.model");
const User = require("../src/models/user.model");
mongoose.connect("mongodb://aditya:9555375817@192.168.1.100:27017/StudyVault?authSource=admin");

async function seed() {
  const creatorId = "PM5hByxxJAdgAWrxiBKiJr5SXD42";
  const notes = [];

  for (let i = 1; i <= 50; i++) {
    notes.push({
      creatorId: "PM5hByxxJAdgAWrxiBKiJr5SXD42",
      title: `Test Note ${i}`,
      subject: "Operating Systems",
      branch: "CSE",
      semester: "Semester IV",
      college: "Gurugram University",
      cloudinaryUrl: "https://dummy-url.com/file.pdf",
      cloudinaryPublicId: "dummy-public-id",
    });
  }

  await Note.insertMany(notes);
  const totalNotes = await Note.countDocuments({ creatorId });
  await User.findOneAndUpdate(
    { firebaseUid: creatorId },
    { totalNotes }
  );
  console.log("50 notes inserted!");

  process.exit();
}

seed();