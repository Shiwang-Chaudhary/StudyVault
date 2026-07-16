const authRouter = require('./auth/auth.route');
const router = require('express').Router();
const notesRouter = require('./notes/notes.routes');

router.use('/auth', authRouter);
// router.use('/notes', notesRouter);
module.exports = router;