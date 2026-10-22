psql (18.6 (Debian 18.6-1.pgdg13+2))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off, ALPN: postgresql)
Type "help" for help.

defaultdb=> 

defaultdb=> CREATE TABLE blogs (
    id SERIAL PRIMARY KEY,
    author TEXT,
    url TEXT NOT NULL,
    title TEXT NOT NULL,
    likes INTEGER DEFAULT 0
);
CREATE TABLE
defaultdb=> \d blogs
                            Table "public.blogs"
 Column |  Type   | Collation | Nullable |              Default              
--------+---------+-----------+----------+-----------------------------------
 id     | integer |           | not null | nextval('blogs_id_seq'::regclass)
 author | text    |           |          | 
 url    | text    |           | not null | 
 title  | text    |           | not null | 
 likes  | integer |           |          | 0
Indexes:
    "blogs_pkey" PRIMARY KEY, btree (id)

defaultdb=> \d
              List of relations
 Schema |     Name     |   Type   |  Owner   
--------+--------------+----------+----------
 public | blogs        | table    | avnadmin
 public | blogs_id_seq | sequence | avnadmin
 public | notes        | table    | avnadmin
 public | notes_id_seq | sequence | avnadmin
(4 rows)

defaultdb=> INSERT INTO blogs (author, url, title, likes)
VALUES
    ('Kuol Buom', 'https://kuolbuom.com/blogs/postgresql', 'Learning PostgreSQL Basics', 5),
    ('John Doe', 'https://example.com/blogs/fullstack', 'Getting Started with Full Stack Development', 10);
INSERT 0 2
defaultdb=> select * from blogs
defaultdb-> select * from blogs;
ERROR:  syntax error at or near "select"
LINE 2: select * from blogs;
        ^
defaultdb=> select * from blogs;
 id |  author   |                  url                  |                    title                    | likes 
----+-----------+---------------------------------------+---------------------------------------------+-------
  1 | Kuol Buom | https://kuolbuom.com/blogs/postgresql | Learning PostgreSQL Basics                  |     5
  2 | John Doe  | https://example.com/blogs/fullstack   | Getting Started with Full Stack Development |    10
(2 rows)

defaultdb=> 


PS C:\Users\Student\Desktop\part13-blog> npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help init` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (part13-blog) blogs app relational database
Sorry, name can only contain URL-friendly characters.
package name: (part13-blog) blogs-app-relational-database
version: (1.0.0) 
description: blogs app with  relational database
entry point: (index.js) cli.js
test command: 
git repository: (https://github.com/kuolbuom/par13.git) 
keywords: 
author: Kuol Buom Patai
license: (ISC) 
type: (commonjs) 
About to write to C:\Users\Student\Desktop\part13-blog\package.json:

{
  "name": "blogs-app-relational-database",
  "version": "1.0.0",
  "description": "blogs app with  relational database",
  "main": "cli.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "url": "git+https://github.com/kuolbuom/par13.git"
  },
  "author": "Kuol Buom Patai",
  "license": "ISC",
  "type": "commonjs",
  "bugs": {
    "url": "https://github.com/kuolbuom/par13/issues"
  },
  "homepage": "https://github.com/kuolbuom/par13#readme"
}


Is this OK? (yes) 

PS C:\Users\Student\Desktop\part13-blog> npm install express dotenv pg sequelize

PS C:\Users\Student\Desktop\part13-blog> node cli.js
◇ injected env (1) from .env
Executing (default): SELECT 1+1 AS result
PS C:\Users\Student\Desktop\part13-blog> node cli.js
◇ injected env (1) from .env
Executing (default): SELECT 1+1 AS result
Unable to connect to the database: ReferenceError: QueryTypes is not defined
    at main (C:\Users\Student\Desktop\part13-blog\cli.js:18:13)
    at process.processTicksAndRejections (node:internal/process/task_queues:103:5)
PS C:\Users\Student\Desktop\part13-blog> node cli.js
◇ injected env (1) from .env
Executing (default): SELECT 1+1 AS result
Executing (default): SELECT * FROM blogs
[
  {
    id: 1,
    author: 'Kuol Buom',
    url: 'https://kuolbuom.com/blogs/postgresql',
    title: 'Learning PostgreSQL Basics',
    likes: 5
  },
  {
    id: 2,
    author: 'John Doe',
    url: 'https://example.com/blogs/fullstack',
    title: 'Getting Started with Full Stack Development',
    likes: 10
  }
]
PS C:\Users\Student\Desktop\part13-blog> 

class Blog extends Model {}
- extends Model — makes Blog a Sequelize model, allowing you to use methods such as Blog.findAll(), Blog.create(), and Blog.findByPk().
id: {
  type: DataTypes.INTEGER,
  primaryKey: true,
  autoIncrement: true,
},


- primaryKey: true — identifies each blog uniquely.
- autoIncrement: true — PostgreSQL generates the next ID automatically.
author: {
  type: DataTypes.STRING,
  allowNull: false,
},


- allowNull: false — prevents the author from being NULL.
- You've correctly applied this to author, url, and title, since these fields are required for your application.
likes: {
  type: DataTypes.INTEGER,
  defaultValue: 0,
},


- Good choice. If you create a blog without specifying likes, Sequelize uses 0.
2. Reviewing your configuration
Setting	Purpose	Review
sequelize	Connects the model to your database connection	Correct
underscored: true	Uses snake_case for automatically generated column names	Good, especially for consistency
timestamps: false	Disables automatic createdAt and updatedAt columns	Correct if you don't need them
modelName: "Blog"	Names the Sequelize model	Correct
One detail to understand: underscored: true normally maps Sequelize's camelCase attributes, such as createdAt, to snake_case database columns, such as created_at. It does not change names like author or likes, which are already lowercase.
3. What I would improve
Improvement 1: Consider DataTypes.TEXT for long text
Your use of DataTypes.STRING is valid. However, PostgreSQL blog titles and URLs are usually fine as strings, while longer article content would be better represented by DataTypes.TEXT.

For your current fields, you don't need to change anything.
Improvement 2: Consider whether author should be required
You've set allowNull: false for author. That is reasonable if every blog must have an author. If your application permits anonymous blog posts, you could allow null values instead.

This is a business rule, not a coding mistake.
Improvement 3: Consider database-level constraints
Your model defines likes as an integer with a default of zero, but it does not prevent negative likes. If your application should never permit negative likes, you could add a validation:
likes: {
  type: DataTypes.INTEGER,
  defaultValue: 0,
  validate: {
    min: 0,
  },
},


This Sequelize validation helps reject negative values through Sequelize operations. If you need the database itself to enforce that rule for every kind of database write, add a PostgreSQL CHECK constraint too.
4. My overall review
Model structure: Good

Field types and defaults: Appropriate

Sequelize configuration: Correct

Optional improvement: Validate that likes is not negative


My recommendation: Keep your model as it is for now. It is suitable for a basic Full Stack Open blog application.

One important mental model to remember:
- The Sequelize model describes how your application works with database records.
- The PostgreSQL table stores the actual records and enforces its own database constraints.
Defining a field in Sequelize does not necessarily mean an existing PostgreSQL table will automatically change to match it. That depends on how you manage your database schema.