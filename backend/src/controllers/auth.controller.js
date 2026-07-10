const asyncHandler = require('express-async-handler');
const User = require('../models/user.model');


const authController = asyncHandler(async(req, res) => {
    const { uid, name, email, picture } = req.user;

    let user = await User.findOne({ uid });

    if(!user){
        // user = new
    }
});