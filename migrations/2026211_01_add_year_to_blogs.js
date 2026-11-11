const { DataTypes } = require("sequelize");

module.exports = {
  up: async ({ context: queryInterface }) => {
    const tableDefinition = await queryInterface.describeTable("blogs");

    if (!tableDefinition.year) {
      await queryInterface.addColumn("blogs", "year", {
        type: DataTypes.INTEGER,
        allowNull: true,
      });
    }
  },

  down: async ({ context: queryInterface }) => {
    const tableDefinition = await queryInterface.describeTable("blogs");

    if (tableDefinition.year) {
      await queryInterface.removeColumn("blogs", "year");
    }
  },
};
