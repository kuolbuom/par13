const express = require("express");
const app = express();

const { PORT } = require("./util/config");

const { connectionToDatabase } = require("./util/db");
const blogsRouter = require("./controllers/blogs");

app.use(express.json());

app.use("/api/blogs", blogsRouter);

const start = async () => {
  await connectionToDatabase();
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
};

start();
