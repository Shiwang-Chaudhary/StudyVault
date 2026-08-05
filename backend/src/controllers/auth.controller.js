const asyncHandler = require("express-async-handler");
const User = require("../models/user.model");
const { ApiError, successResponse } = require("../utils/apiResponse.utils");

const authController = asyncHandler(async (req, res) => {
  try {
    const { uid, name, email, picture } = req.firebaseUser;

    let user = await User.findOne({
      firebaseUid: uid,
    });

    if (!user) {
      user = await User.create({
        firebaseUid: uid,
        name,
        email,
        photoUrl: picture ?? null,
      });

      console.log(`✅ New user created: ${email}`);
    }

    return successResponse(res, 200, user);
  } catch (err) {
    console.error(
      `❌ Error occurred while authenticating user: ${err.message}`,
    );

    throw new ApiError(
      500,
      "Internal Server Error",
      err.message,
    );
  }
});

module.exports = authController;