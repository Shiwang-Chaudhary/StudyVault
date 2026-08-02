admin = require("firebase-admin");

console.log("Project:", process.env.FIREBASE_PROJECT_ID);
console.log("Email:", process.env.FIREBASE_CLIENT_EMAIL);
console.log(
  "Private Key starts with:",
  process.env.FIREBASE_PRIVATE_KEY?.substring(0, 30)
);
admin.initializeApp({
    credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        // privateKey: process.env.FIREBASE_PRIVATE_KEY,
        privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n"),
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL
    })
});

module.exports = admin;