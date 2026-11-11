const router = require("express").Router();

const Session = require("../models/session");
const { userExtractor } = require("../util/middleware");

// Log out the currently authenticated user.
router.delete("/", userExtractor, async (req, res, next) => {
  try {
    await Session.destroy({
      where: {
        token: req.token,
      },
    });

    res.status(204).end();
  } catch (error) {
    next(error);
  }
});

module.exports = router;
