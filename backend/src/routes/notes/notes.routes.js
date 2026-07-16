const router = require('express').Router();
// const notesController = require('../../controllers/notes.controller');
const authMiddleware = require('../../middleware/auth.middleware');

// router.post('/upload', authMiddleware, notesController.uploadNote);