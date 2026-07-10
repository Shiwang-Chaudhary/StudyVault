require('dotenv').config();

const app = require('./app');
const PORT = process.env.PORT || 5000;
const connectDB = require('./config/mongodb.config');

app.listen(PORT, () =>{
    connectDB();
    console.log(`🚀 StudyVault API running on port ${PORT}`);
});