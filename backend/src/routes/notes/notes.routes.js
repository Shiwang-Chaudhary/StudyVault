const router = require('express').Router();
// const notesController = require('../../controllers/notes.controller');
const authMiddleware = require('../../middleware/auth.middleware');
const upload  = require('../../middleware/upload.middlware');

// router.post('/upload', authMiddleware, upload.single('pdf'), notesController.uploadNote);

module.exports = router;