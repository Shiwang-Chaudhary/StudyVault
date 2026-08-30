const admin = require("firebase-admin");
const asyncHandler = require("express-async-handler");
const { ApiError } = require("../utils/apiResponse.utils");

const firebaseAuthMiddleware = asyncHandler(async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if(!authHeader || !authHeader.startsWith("Bearer ")){
        throw new ApiError(401, "Unauthorized: Invalid or missing authorization header");
    }
    const idToken = authHeader.split(" ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);

    req.firebaseUser = decodedToken;
    next();
  });

module.exports = firebaseAuthMiddleware;