const router = require("express").Router();
const { User, Blog } = require("../models");

// GET all users
router.get("/", async (req, res, next) => {
  try {
    const users = await User.findAll({
      // Let's change the route that returns all users so that each user's blogs are also shown:
      include: {
        model: Blog,
        attributes: { exclude: ["userId"] },
      },
    });
    res.json(users);
  } catch (error) {
    next(error);
  }
});

// POST create a user
router.post("/", async (req, res, next) => {
  try {
    const user = await User.create({
      username: req.body.username,
      name: req.body.name,
    });

    res.status(201).json(user);
  } catch (error) {
    next(error);
  }
});

// PUT update a user's name using username
// PUT /:username	User.findOne() + user.update()	Changes the user's name.
router.put("/:username", async (req, res, next) => {
  try {
    const user = await User.findOne({
      where: {
        username: req.params.username,
      },
    });

    if (!user) {
      return res.status(404).json({
        error: "User not found",
      });
    }

    await user.update({
      name: req.body.name,
    });

    res.json(user);
  } catch (error) {
    next(error);
  }
});

// GET one user using ID
router.get("/:id", async (req, res, next) => {
  try {
    const user = await User.findByPk(req.params.id);

    if (!user) {
      return res.status(404).json({
        error: "User not found",
      });
    }

    res.json(user);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
