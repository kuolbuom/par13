// The route handling associated with notes can be found in the file controllers/notes.js:
const router = require("express").Router();

const Blog = require("../models/blog");
const { userExtractor } = require("../util/middleware");

router.get("/", async (req, res) => {
  const blogs = await Blog.findAll();
  res.json(blogs);
});

// const tokenExtractor = (req, res, next) => {
//   const authorization = req.get("authorization");
//   if (authorization && authorization.toLowerCase().startsWith("bearer ")) {
//     try {
//       req.decodedToken = jwt.verify(authorization.substring(7), SECRET);
//     } catch {
//       return res.status(401).json({ error: "token invalid" });
//     }
//   } else {
//     return res.status(401).json({ error: "token missing" });
//   }
//   next();
// };

router.post("/", userExtractor, async (req, res, next) => {
  try {
    // try attempts to create the blog.
    const blog = await Blog.create({
      // ...req.body copies the blog information submitted by the client.
      ...req.body,
      // userId: req.user.id assigns ownership to the authenticated user.
      // let's hard code the blog to be attached to the first user found in the database:
      userId: req.user.id,
    });
    res.json(blog);
  } catch (error) {
    // catches a failure.
    // next(error) passes that failure to Express's error-handling middleware.
    next(error);
  }
});

const blogFinder = async (req, res, next) => {
  req.blog = await Blog.findByPk(req.params.id);
  next();
};

router.delete("/:id", userExtractor, blogFinder, async (req, res, next) => {
  const blog = req.blog;

  try {
    const blog = req.blog;

    if (blog.userId !== req.user.id) {
      return res.status(403).json({
        error: "only the user who added this blog can delete it",
      });
    }

    await blog.destroy();

    return res.status(204).end();
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
