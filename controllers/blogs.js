// The route handling associated with notes can be found in the file controllers/notes.js:
const router = require("express").Router();

const Blog = require("../models/blog");

router.get("/", async (req, res) => {
  const blogs = await Blog.findAll();
  res.json(blogs);
});

router.post("/", async (req, res) => {
  try {
    const blog = await Blog.create(req.body);
    res.json(blog);
  } catch (error) {
    res.status(400).json({ error });
  }
});

const blogFinder = async (req, res, next) => {
  req.blog = await Blog.findByPk(req.params.id);
  next();
};

router.delete("/:id", blogFinder, async (req, res) => {
  const blog = req.blog;
  if (blog) {
    await blog.destroy();
    res.status(204).end();
  } else {
    res.status(404).json({ error });
  }
});

router.put("/:id", blogFinder, async (req, res) => {
  const blog = req.blog;
  if (blog) {
    await blog.update(req.body);
    res.json(blog);
  } else {
    res.status(404).json({ error });
  }
});

module.exports = router;
