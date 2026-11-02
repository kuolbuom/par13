const Sequelize = require("sequelize");

const { DATABASE_URL, TEST_DATABASE_URL } = require("./config");

const connectionString =
  process.env.TESTING === "true" ? TEST_DATABASE_URL : DATABASE_URL;

//sequelize is needed by the Blog model, so we export it here
const sequelize = new Sequelize(connectionString, {
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

    const [result] = await sequelize.query(
      "SELECT current_database() AS database",
    );

    console.log("Connected database:", result[0].database);
    console.log("Connection to the database established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }
};

module.exports = {
  sequelize,
  connectionToDatabase,
};
