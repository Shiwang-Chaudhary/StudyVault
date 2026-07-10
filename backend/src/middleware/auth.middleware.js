const asyncHandler = require('express-async-handler');
const ApiError = require('../utils/apiResponse.utils');
const admin = require('../config/firebase.config');


const authMiddleware = asyncHandler(async (req, res, next) => {

    const authHeader = req.headers.authorization;
    if(!authHeader || !authHeader.startsWith("Bearer ")){
        throw new ApiError(401, "Unauthorized: Invalid or missing authorization header");
    }

    const idToken = authHeader.split(" ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    //decodedToken will contain the user's information, such as uid, email, etc.
    //It look like this:
    /*
        {
            uid: "fJ3kLp92abc",
            email: "john@gmail.com",
            email_verified: true,
            name: "John Doe",
            picture: "https://...",
            firebase: {
                sign_in_provider: "password"
            },
            iat: 1720400000,
            exp: 1720403600
        }
    */
    req.user = decodedToken;
    //req become like this:
    /*
    req = {
        headers: {...},
        body: {},
        params: {},
        query: {},

        user: {
            uid: "fJ3kLp92abc",
            email: "john@gmail.com",
            email_verified: true,
            ...
        }
    }
  */
    next();
});

module.exports = authMiddleware;