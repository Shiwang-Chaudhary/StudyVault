const router = require("express").Router();

const authMiddleware = require("../../middleware/auth.middleware");
const upload = require("../../middleware/upload.middlware");

const {
  uploadNote,
  listNotes,
  getMyNotes,
  getNoteById,
  updateNote,
  deleteNote,
  downloadNote
} = require("../../controllers/notes.controller");

// POST /api/notes
// Upload a new note
router.post("/", authMiddleware, upload.single("pdf"), uploadNote);

// GET /api/notes
// Examples:
// GET /api/notes
// GET /api/notes?search=flutter
// GET /api/notes?subject=DBMS
// GET /api/notes?college=ABC
// GET /api/notes?semester=5
// GET /api/notes?sort=latest
router.get("/",
    //  authMiddleware,
      listNotes);

// GET /api/notes/my
// Get logged-in user's uploaded notes
router.get("/my", authMiddleware, getMyNotes);

// GET /api/notes/:id
// Get a single note
router.get("/:id",authMiddleware, getNoteById);
router.get("/:id/download",
    // authMiddleware,
    downloadNote);

// PATCH /api/notes/:id
// Update note details
router.patch("/:id", authMiddleware, updateNote);

// DELETE /api/notes/:id
// Delete a note
router.delete("/:id", authMiddleware, deleteNote);

module.exports = router;