// confiure and launch the application
const express = require("express");
const app = express();

const { PORT } = require("./util/config");

const { connectionToDatabase } = require("./util/db");
const blogsRouter = require("./controllers/blogs");
const usersRouter = require("./controllers/users");

app.use(express.json());

app.use("/api/blogs", blogsRouter);
app.use("/api/users", usersRouter);

const errorHandler = (error, req, res, next) => {
  console.error(error.message);

  if (error.name === "SequelizeValidationError") {
    return res.status(400).json({
      error: error.message,
    });
  }

  next(error);
};

app.use(errorHandler);

const start = async () => {
  await connectionToDatabase();
  // listening for the network request
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
};

start();
