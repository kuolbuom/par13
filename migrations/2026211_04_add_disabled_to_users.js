const { DataTypes } = require("sequelize");

module.exports = {
  up: async ({ context: queryInterface }) => {
    const tableDefinition = await queryInterface.describeTable("users");

    if (!tableDefinition.disabled) {
      await queryInterface.addColumn("users", "disabled", {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      });
    }
  },

  down: async ({ context: queryInterface }) => {
    const tableDefinition = await queryInterface.describeTable("users");

    if (tableDefinition.disabled) {
      await queryInterface.removeColumn("users", "disabled");
    }
  },
};
