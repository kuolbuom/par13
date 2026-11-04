// confiure and launch the application
const express = require("express");
const app = express();

const { PORT } = require("./util/config");

const { connectionToDatabase, sequelize } = require("./util/db");
const blogsRouter = require("./controllers/blogs");
const usersRouter = require("./controllers/users");
const loginRouter = require("./controllers/login");
const authorsRouter = require("./controllers/author-route");

// const { syncModels } = require("./models");
const { tokenExtractor } = require("./util/middleware");

app.use(express.json());
app.use(tokenExtractor);

//reset route for testing purposes
// router.post("/reset", async (req, res) => {
//   await Blog.destroy({
//     where: {},
//     truncate: true,
//     cascade: true,
//   });

//   await User.destroy({
//     where: {},
//     truncate: true,
//     cascade: true,
//   });

//   res.status(204).end();
// });

app.get("/", (req, res) => {
  res.sendStatus(200);
});

app.post("/api/reset", async (req, res) => {
  if (process.env.TESTING !== "true") {
    return res.sendStatus(404);
  }

  await sequelize.truncate({
    cascade: true,
    restartIdentity: true,
  });

  res.status(204).end();
});

app.use("/api/blogs", blogsRouter);
app.use("/api/users", usersRouter);
app.use("/api/login", loginRouter);
app.use("/api/authors", authorsRouter);

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
  // await syncModels();
  // listening for the network request
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
};

start();
