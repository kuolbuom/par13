const router = require("express").Router();
const { User, Blog, ReadingList } = require("../models");
const { userExtractor } = require("../util/middleware");

router.post("/", async (req, res, next) => {
  try {
    const { userId, blogId } = req.body;
    const parsedUserId = Number(userId);
    const parsedBlogId = Number(blogId);

    // 1. Validate that IDs are provided and are positive integers
    if (
      !Number.isInteger(parsedUserId) ||
      !Number.isInteger(parsedBlogId) ||
      parsedUserId <= 0 ||
      parsedBlogId <= 0
    ) {
      return res.status(400).json({
        error: "userId and blogId must be positive integers",
      });
    }

    // 2. Check whether the user exists
    const user = await User.findByPk(parsedUserId);

    if (!user) {
      return res.status(404).json({
        error: "User not found",
      });
    }

    // 3. Check whether the blog exists
    const blog = await Blog.findByPk(parsedBlogId);

    if (!blog) {
      return res.status(404).json({
        error: "Blog not found",
      });
    }

    const existingEntry = await ReadingList.findOne({
      where: {
        userId: parsedUserId,
        blogId: parsedBlogId,
      },
    });

    if (existingEntry) {
      return res.status(400).json({
        error: "Blog already exists in reading list",
      });
    }

    // 4. Create the reading-list entry
    const reading = await ReadingList.create({
      userId: parsedUserId,
      blogId: parsedBlogId,
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
      return res.status(401).json({
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
