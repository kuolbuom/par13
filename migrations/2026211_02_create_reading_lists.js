module.exports = {
  up: async ({ context: queryInterface }) => {
    const { DataTypes } = require("sequelize");

    await queryInterface.createTable("reading_lists", {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      //This part of the migration creates a foreign key:
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: "users",
          key: "id",
        },
        onDelete: "CASCADE",
      },
      //This part of the migration creates a foreign key:
      blog_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        // The important concept: references is what tells Sequelize to create a foreign-key relationship in PostgreSQL.
        references: {
          model: "blogs",
          key: "id",
        },
        onDelete: "CASCADE",
      },

      read: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },

      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },

      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
    });

    await queryInterface.addConstraint("reading_lists", {
      fields: ["user_id", "blog_id"],
      type: "unique",
      name: "reading_lists_user_id_blog_id_unique",
    });
  },

  down: async ({ context: queryInterface }) => {
    await queryInterface.dropTable("reading_lists");
  },
};
