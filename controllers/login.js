const jwt = require("jsonwebtoken");
const router = require("express").Router();

const { SECRET } = require("../util/config");
const User = require("../models/user");
const Session = require("../models/session");

const bcrypt = require("bcrypt");

router.get("/", async (req, res) => {
  //wait for all users in database if found
  const users = await User.findAll();
  res.json(users);
});

router.post("/", async (request, response) => {
  //client request payload with username, password
  const body = request.body;

  //wait for user for user from database if the username matches the username in the request body
  const user = await User.findOne({
    where: {
      username: body.username,
    },
  });

  //check whether password in request.body matches secret and stored it here -> passwordCorrect
  // const passwordCorrect = body.password === "secret";
  const passwordCorrect = user
    ? // checks whether the submitted password matches the stored hash.
      await bcrypt.compare(body.password, user.passwordHash)
    : // If the username does not exist, it sets passwordCorrect to false without trying to compare anything.
      false;
  //if no user in database and valid password, stop send 401 and error msg to client
  if (!(user && passwordCorrect)) {
    return response.status(401).json({
      error: "invalid username or password",
    });
  }

  // Prevent disabled users from logging in
  if (user.disabled) {
    return response.status(403).json({
      error: "account disabled, please contact admin",
    });
  }

  //create payload or object carring username, id and save it in userForToken variable
  const userForToken = {
    username: user.username,
    id: user.id,
  };

  //generate authentication token and asign the user by payload and secret
  const token = jwt.sign(userForToken, SECRET);

  // Save the active session in the database
  //This is the central part of the exercise.
  await Session.create({
    token,
    userId: user.id,
  });

  //response with 200 succeeded and send token, username, name
  response
    .status(200)
    .send({ token, username: user.username, name: user.name });
});

module.exports = router;

// Remember the difference:
// - JWT authentication: the token identifies the user.
// - Server-side sessions: the database stores active tokens so the server can manage and invalidate them.
