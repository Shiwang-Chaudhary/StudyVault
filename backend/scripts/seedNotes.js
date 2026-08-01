const mongoose = require("mongoose");
const Note = require("../src/models/notes.model");

mongoose.connect("mongodb://aditya:9555375817@192.168.1.100:27017/StudyVault?authSource=admin");

async function seed() {
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

  console.log("50 notes inserted!");

  process.exit();
}

seed();