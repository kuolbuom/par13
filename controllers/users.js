const router = require("express").Router();
const { User, Blog } = require("../models");

const bcrypt = require("bcrypt");

// GET all users
router.get("/", async (req, res, next) => {
  try {
    const users = await User.findAll({
      attributes: { exclude: ["passwordHash"] },
      // Let's change the route that returns all users so that each user's blogs are also shown:
      include: {
        model: Blog,
        as: "blogs",
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
    const saltRounds = 10;
    // Converts the password into a secure hash.
    const passwordHash = await bcrypt.hash(req.body.password, saltRounds);

    const user = await User.create({
      username: req.body.username,
      name: req.body.name,
      passwordHash,
    });

    res.status(201).json({
      id: user.id,
      username: user.username,
      name: user.name,
    });
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

    res.json({
      id: user.id,
      username: user.username,
      name: user.name,
    });
  } catch (error) {
    next(error);
  }
});

// GET one user using ID
router.get("/:id", async (req, res, next) => {
  try {
    const user = await User.findByPk(req.params.id, {
      attributes: { exclude: ["passwordHash"] },
      include: {
        model: Blog,
        as: "readings",
        attributes: { exclude: ["userId"] },
        through: {
          attributes: [],
        },
      },
    });

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
