const router = require("express").Router();
const { User, Blog, ReadingList } = require("../models");
const { userExtractor } = require("../util/middleware");

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

router.put("/:id", userExtractor, async (req, res, next) => {
  try {
    const readingList = await ReadingList.findByPk(req.params.id);

    if (!readingList) {
      return res.status(404).json({
        error: "Reading list entry not found",
      });
    }

    if (readingList.userId !== req.user.id) {
      return res.status(403).json({
        error: "You can only update your own reading list",
      });
    }

    if (typeof req.body.read !== "boolean") {
      return res.status(400).json({
        error: "read must be a boolean",
      });
    }

    readingList.read = req.body.read;

    await readingList.save();

    res.json(readingList);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
