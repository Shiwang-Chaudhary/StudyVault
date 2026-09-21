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
  downloadNote,
  bookmarkNote,
  getBookmarks,
  deleteBookmark,
  rateNote,
  getNoteRatings,
  getTrendingNotes,
  getRecommendedNotes
} = require("../../controllers/notes.controller");

//POST
router.post("/", authMiddleware, upload.single("pdf"), uploadNote);
router.post("/:noteId/bookmark", authMiddleware, bookmarkNote);
router.post("/:noteId/rating", authMiddleware, rateNote);

//GET
router.get("/", authMiddleware, listNotes);
router.get("/my", authMiddleware, getMyNotes);
router.get("/my/bookmarks", authMiddleware, getBookmarks);
router.get("/trending", getTrendingNotes);
router.get("/recommended", getRecommendedNotes);
router.get("/:noteId",authMiddleware, getNoteById);
router.get("/:noteId/download", authMiddleware, downloadNote);
router.get("/:noteId/ratings", authMiddleware,getNoteRatings);

//PATCH
router.patch("/:noteId", authMiddleware, updateNote);

//DELETE
router.delete("/:noteId/bookmark", authMiddleware, deleteBookmark);
router.delete("/:noteId", authMiddleware, deleteNote);

module.exports = router;