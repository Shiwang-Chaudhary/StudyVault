const express = require('express');
const router = express.Router();
const authMiddleware = require('../../middleware/auth.middleware');
const authController = require("../../controllers/auth.controller");
const onboardingController = require("../../controllers/onboarding.controller");

router.post('/google', authMiddleware, authController);
router.patch('/onboarding', authMiddleware, onboardingController);

module.exports = router;