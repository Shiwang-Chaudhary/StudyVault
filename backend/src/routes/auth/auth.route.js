const express = require('express');
const router = express.Router();
const authMiddleware = require('../../middleware/auth.middleware');
const authController = require("../../controllers/auth.controller")

router.post('/google', authMiddleware, authController);
router.post('/onboarding', authMiddleware, authController);

module.exports = router;