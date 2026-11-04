const Sequelize = require("sequelize");

const { DATABASE_URL, TEST_DATABASE_URL } = require("./config");

const { Umzug, SequelizeStorage } = require("umzug");

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

const runMigrations = async () => {
  const migrator = new Umzug({
    migrations: {
      glob: "migrations/*.js",
    },
    storage: new SequelizeStorage({ sequelize, tableName: "migrations" }),
    context: sequelize.getQueryInterface(),
    logger: console,
  });

  const migrations = await migrator.up();
  console.log("Migrations up to date", {
    files: migrations.map((mig) => mig.name),
  });
};

const connectionToDatabase = async () => {
  try {
    await sequelize.authenticate();
    await runMigrations();
    const [result] = await sequelize.query(
      "SELECT current_database() AS database",
    );

    console.log("Connected database:", result[0].database);
    console.log("Connection to the database established successfully.");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
    console.log(error);
    return process.exit(1);
  }
};

module.exports = {
  sequelize,
  connectionToDatabase,
};
