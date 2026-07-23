const router = require('express').Router();
const authMiddleware = require('../../middleware/auth.middleware');
const upload  = require('../../middleware/upload.middlware');
const { uploadNote, listNotes } = require('../../controllers/notes.controller');

router.post('/upload', authMiddleware, upload.single('pdf'), uploadNote);
router.get('/list', authMiddleware, listNotes);

module.exports = router;