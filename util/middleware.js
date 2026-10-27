const jwt = require("jsonwebtoken");
const { SECRET } = require("./config");
const User = require("../models/user");

// Extracts the JWT from the request header.
const tokenExtractor = (request, response, next) => {
  const authorization = request.get("authorization");

  if (authorization && authorization.toLowerCase().startsWith("bearer ")) {
    request.token = authorization.substring(7);
  } else {
    request.token = null;
  }

  next();
};

// Verifies the JWT and finds the corresponding user.
const userExtractor = async (request, response, next) => {
  if (!request.token) {
    return response.status(401).json({
      // this happen when attemptig to login without token at all
      error: "token missing",
    });
  }

  let decodedToken;

  try {
    decodedToken = jwt.verify(request.token, SECRET);
  } catch (error) {
    return response.status(401).json({
      // when you have token but not your token or missing something forexample charater/s
      error: "token invalid",
    });
  }

  try {
    const user = await User.findByPk(decodedToken.id);

    if (!user) {
      return response.status(401).json({
        error: "user not found",
      });
    }

    //This makes the authenticated user available to subsequent middleware and route handlers.
    //For example, your blog route can now access: request.user.id, request.user.username
    request.user = user;
    next();
  } catch (error) {
    next(error);
  }
};

module.exports = {
  tokenExtractor,
  userExtractor,
};
