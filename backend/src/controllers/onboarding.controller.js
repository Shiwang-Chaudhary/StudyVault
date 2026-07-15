const asyncHandler = require("express-async-handler");
const User = require("../models/user.model");
const { ApiError, successResponse } = require("../utils/apiResponse.utils");

const onboardingController = asyncHandler(async (req, res) => {
    const{college, branch, semester, subjects} = req.body;
    const user = await User.findOne({firebaseUid: req.user.uid});
    if (!college || !branch || !semester || !Array.isArray(subjects)) {
        throw new ApiError(
            400,
            "college, branch, semester and subjects are required."
    );
}
    if(!user){
        throw new ApiError(404, "User not found");
    }

    user.college = college;
    user.branch = branch;
    user.semester = semester;
    user.subjects = subjects;

    await user.save();

    return successResponse(res, 200, user);
});

module.exports = onboardingController;