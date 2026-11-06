const router = require("express").Router();
const { User, Blog, ReadingList } = require("../models");

router.post("/", async (req, res, next) => {
  try {
    const { userId, blogId } = req.body;

    // 1. Validate that IDs are provided and are positive integers
    if (
      !Number.isInteger(userId) ||
      !Number.isInteger(blogId) ||
      userId <= 0 ||
      blogId <= 0
    ) {
      return res.status(400).json({
        error: "userId and blogId must be positive integers",
      });
    }

    // 2. Check whether the user exists
    const user = await User.findByPk(userId);

    if (!user) {
      return res.status(404).json({
        error: "User not found",
      });
    }

    // 3. Check whether the blog exists
    const blog = await Blog.findByPk(blogId);

    if (!blog) {
      return res.status(404).json({
        error: "Blog not found",
      });
    }

    // 4. Create the reading-list entry
    const reading = await ReadingList.create({
      userId,
      blogId,
    });

    res.status(201).json(reading);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
