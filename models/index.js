const Blog = require("./blog");
const User = require("./user");
const ReadingList = require("./readingLists");
const Session = require("./session");

User.hasMany(Session);
Session.belongsTo(User);

//represents blogs created by a user.
User.hasMany(Blog, {
  as: "blogs",
});

Blog.belongsTo(User, {
  as: "user",
});

// New relationships: reading list
//represents blogs that a user wants to read.
User.belongsToMany(Blog, {
  through: ReadingList,
  as: "readings",
  foreignKey: "userId",
  otherKey: "blogId",
});

Blog.belongsToMany(User, {
  through: ReadingList,
  as: "readers",
  foreignKey: "blogId",
  otherKey: "userId",
});

// const syncModels = async () => {
//   // force: true drops and recreates the table, removing old rows and creating the new password_hash column.
//   // alter: true updates the normal database schema without intentionally dropping the tables.
//   if (process.env.TESTING === "true") {
//     await User.sync({ force: true });
//     await Blog.sync({ force: true });
//   } else {
//     await User.sync({ alter: true });
//     await Blog.sync({ alter: true });
//   }
// };

module.exports = {
  Blog,
  User,
  ReadingList,
  Session,
  // syncModels,
};
