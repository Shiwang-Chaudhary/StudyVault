const express = require('express');
const router = express.Router();
const authMiddleware = require('../../middleware/auth.middleware');
const authController = require("../../controllers/auth.controller");
const onboardingController = require("../../controllers/onboarding.controller");
const firebaseAuthMiddleware = require("../../middleware/firebaseAuth.middleware");

router.post('/google', firebaseAuthMiddleware, authController);
router.patch('/onboarding', authMiddleware, onboardingController);

module.exports = router;