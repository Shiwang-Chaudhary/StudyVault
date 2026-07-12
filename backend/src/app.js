const express = require('express');
const app = express();
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const notfoundHandler = require('./middleware/notfound.middlware');
const errorHandler = require('./middleware/errorHandler.middleware');
const routes = require('./routes/index');

app.use(cors());
app.use(helmet());
app.use(express.json());
app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));

//Routes
app.get("/", (req, res) => {
    res.json({ message: "Welcome to StudyVault API" });
});
app.use("/api", routes);

app.use(notfoundHandler);
app.use(errorHandler);

module.exports = app;

