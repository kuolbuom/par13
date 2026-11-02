const Blog = require("./blog");
const User = require("./user");

User.hasMany(Blog, {
  as: "blogs",
});

Blog.belongsTo(User, {
  as: "user",
});

const syncModels = async () => {
  // force: true drops and recreates the table, removing old rows and creating the new password_hash column.
  // alter: true updates the normal database schema without intentionally dropping the tables.
  if (process.env.TESTING === "true") {
    await User.sync({ force: true });
    await Blog.sync({ force: true });
  } else {
    await User.sync({ alter: true });
    await Blog.sync({ alter: true });
  }
};

module.exports = {
  Blog,
  User,
  syncModels,
};
