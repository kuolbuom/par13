const Sequelize = require("sequelize");

const { DATABASE_URL } = require("./config");
//sequelize is needed by the Blog model, so we export it here
const sequelize = new Sequelize(DATABASE_URL, {
  dialect: "postgres",
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  },
});

const connectionToDatabase = async () => {
  try {
    await sequelize.authenticate();
    console.log("Connection to the database established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }
};

module.exports = {
  sequelize,
  connectionToDatabase,
};
