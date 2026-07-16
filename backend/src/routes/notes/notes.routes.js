const router = require('express').Router();
const authMiddleware = require('../../middleware/auth.middleware');
const upload  = require('../../middleware/upload.middlware');
const { uploadNote } = require('../../controllers/notes.controller');

router.post('/upload', authMiddleware, upload.single('pdf'), uploadNote);

module.exports = router;