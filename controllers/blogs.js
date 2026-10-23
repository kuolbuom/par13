// The route handling associated with notes can be found in the file controllers/notes.js:
const router = require("express").Router();

const Blog = require("../models/blog");

router.get("/", async (req, res) => {
  const blogs = await Blog.findAll();
  res.json(blogs);
});

router.post("/", async (req, res, next) => {
  try {
    // try attempts to create the blog.
    const blog = await Blog.create(req.body);
    res.json(blog);
  } catch (error) {
    // catch catches a failure.
    // next(error) passes that failure to Express's error-handling middleware.
    next(error);
  }
});

const blogFinder = async (req, res, next) => {
  req.blog = await Blog.findByPk(req.params.id);
  next();
};

router.delete("/:id", blogFinder, async (req, res, next) => {
  try {
    const blog = req.blog;
    if (blog) {
      await blog.destroy();
      res.status(204).end();
    } else {
      res.status(404).json({ error });
    }
  } catch (error) {
    next(error);
  }
});

router.put("/:id", blogFinder, async (req, res, next) => {
  try {
    const blog = req.blog;
    if (blog) {
      await blog.update(req.body);
      res.json(blog);
    } else {
      res.status(404).json({ error });
    }
  } catch (error) {
    next(error);
  }
});

module.exports = router;
