// confiure and launch the application
const express = require("express");
const app = express();

const { PORT } = require("./util/config");

const { connectionToDatabase } = require("./util/db");
const blogsRouter = require("./controllers/blogs");
const usersRouter = require("./controllers/users");
const loginRouter = require("./controllers/login");
const { syncModels } = require("./models");
const { tokenExtractor } = require("./util/middleware");

app.use(express.json());
app.use(tokenExtractor);

app.use("/api/blogs", blogsRouter);
app.use("/api/users", usersRouter);
app.use("/api/login", loginRouter);

const errorHandler = (error, req, res, next) => {
  console.error(error.message);

  if (
    error.name === "SequelizeValidationError" ||
    error.name === "SequelizeUniqueConstraintError"
  ) {
    return res.status(400).json({
      error: error.errors.map((e) => e.message),
    });
  }

  next(error);
};

app.use(errorHandler);

const start = async () => {
  await connectionToDatabase();
  await syncModels();
  // listening for the network request
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
};

start();
