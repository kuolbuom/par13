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

This error is related to Sequelize trying to add timestamp columns to your existing users table, but PostgreSQL is refusing because the table already contains records.

Let's understand what is happening.
1. Identify the exact problem
Look at this SQL statement:
ALTER TABLE "public"."users"
ADD COLUMN "created_at" TIMESTAMP WITH TIME ZONE NOT NULL;


Sequelize is asking PostgreSQL to:
1. Open the users table.
2. Add a new column called created_at.
3. Make its data type TIMESTAMP WITH TIME ZONE.
4. Require every row to have a value (NOT NULL).
But PostgreSQL responds:
column "created_at" of relation "users" contains null values


Why?

Your users table already has existing records. When PostgreSQL adds a new column, those existing records initially have no value for that column (NULL).

However, you are asking PostgreSQL to make that column NOT NULL.

That creates a conflict.
2. Why is Sequelize doing this?
Look at your stack trace:
at async user.sync
at async syncModels (models/index.js:8:3)
at async start (cli.js:40:3)


This tells us that your application calls:
await user.sync()


Your User model probably has Sequelize timestamps enabled.

By default, Sequelize automatically manages two timestamp columns:
- createdAt – when a record was created.
- updatedAt – when a record was last updated.
Because your database uses snake_case naming, Sequelize is trying to create:
created_at
updated_at


Your existing table doesn't have these columns.
3. Three ways to solve this
Option A: Disable timestamps

If you don't need automatic timestamps for your User model:
const User = sequelize.define("User", {
  username: DataTypes.STRING,
  name: DataTypes.STRING,
}, {
  underscored: true,
  timestamps: false,
});


Option B: Add default values

If you want timestamps, you can configure defaults in your model:
createdAt: {
  type: DataTypes.DATE,
  allowNull: false,
  defaultValue: DataTypes.NOW,
},


This is one way to handle new records, but for existing database rows you still need a migration or SQL update before enforcing NOT NULL.

Option C: Use a database migration

This is the more controlled approach for an existing database. You can add the columns, populate existing records, and then enforce NOT NULL.

4. Let's investigate before changing anything
Since you're learning Sequelize and PostgreSQL in Full Stack Open, I recommend that we understand your existing schema before modifying it.

In your PostgreSQL terminal (psql), execute:
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'users'
AND table_schema = 'public';


This will show us:
- Which columns currently exist.
- Their data types.
- Whether they allow NULL values.
Send me the output and your User model definition.

We'll identify whether you should disable timestamps or add them properly without losing your existing users.

One important lesson: Model.sync() is useful while developing, but when your database already contains important records, migrations give you much better control over schema changes.

Exactly. I agree with your thinking. We should keep timestamps enabled because they are useful in a real application.

The important thing is to understand the difference between existing records and new records.

Let's solve this properly without deleting your existing users.
1. Understand our plan
We want the following:
Situation	       What should happen?
Existing users	 Give them a timestamp
New users	       Automatically assign the current timestamp
created_at	     Must NOT be NULL
updated_at	     Must NOT be NULL

We can achieve this using PostgreSQL defaults.
2. First, inspect your existing table
Open your PostgreSQL terminal and execute:
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'users'
AND table_schema = 'public';


This helps us understand the current structure before making changes.
3. What we will eventually do
For an existing database, the migration logic will look like this:

Step 1: Add the columns with defaults.
ALTER TABLE users
ADD COLUMN created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users
ADD COLUMN updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;


Step 2: Make sure existing records have values.
UPDATE users
SET created_at = CURRENT_TIMESTAMP
WHERE created_at IS NULL;

UPDATE users
SET updated_at = CURRENT_TIMESTAMP
WHERE updated_at IS NULL;


Step 3: Enforce NOT NULL.
ALTER TABLE users
ALTER COLUMN created_at SET NOT NULL;

ALTER TABLE users
ALTER COLUMN updated_at SET NOT NULL;


Now both existing and future records have valid timestamps.
4. Configure your Sequelize model
Your model can also define:
createdAt: {
  type: DataTypes.DATE,
  allowNull: false,
  defaultValue: DataTypes.NOW,
},
updatedAt: {
  type: DataTypes.DATE,
  allowNull: false,
  defaultValue: DataTypes.NOW,
},


Keep timestamps: true (the default) and underscored: true.

One important detail: Sequelize automatically updates updatedAt when updating a record.

Let's do this one step at a time.

First, run the inspection query in section 2 and share the output.

I want to see your actual table structure before we execute any ALTER statements. We should avoid accidentally duplicating columns or changing existing data.

Good, this output tells us exactly what happened. Don't worry; your existing users haven't been deleted.

The important clue is this message:
HINT: Perhaps you meant to reference the column "users.updated_at".


It tells us that updated_at exists, but created_at does not.

Let's reconstruct what happened.
1. What happened?
You executed two ALTER TABLE statements:
ALTER TABLE users
ADD COLUMN updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;


It appears this one succeeded.

But the created_at column was never successfully added.

That's why:
- UPDATE users SET created_at... failed.
- ALTER COLUMN created_at SET NOT NULL failed.
- updated_at operations succeeded.
2. Let's fix it
Execute this command first:
ALTER TABLE users
ADD COLUMN created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

Expected response:
ALTER TABLE

3. Verify both columns
Run:
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'users'
AND table_schema = 'public';

Let's first implement the possibility to retrieve only important or non-important notes. Let's implement this using the query-parameter(opens in a new tab) important:

router.get('/', async (req, res) => {
  const notes = await Note.findAll({
    attributes: { exclude: ['userId'] },
    include: {
      model: User,
      attributes: ['name']
    },
    where: {
      important: req.query.important === "true"    
    }  
  })
  res.json(notes)
})

Now the backend can retrieve important notes with a request to http://localhost:3001/api/notes?important=true(opens in a new tab) and non-important notes with a request to http://localhost:3001/api/notes?important=false(opens in a new tab)

Unfortunately, this implementation will not work if the request is not interested in whether the note is important or not, i.e. if the request is made to http://localhost:3001/api/notes(opens in a new tab). The correction can be done in several ways. One, but perhaps not the best way to do the correction would be as follows:


const { Op } = require('sequelize')

router.get('/', async (req, res) => {
  let important = { [Op.in]: [true, false] }  

  if ( req.query.important ) {
    important = req.query.important === "true"
  }
  
  const notes = await Note.findAll({
    attributes: { exclude: ['userId'] },
    include: {
      model: User,
      attributes: ['name']
    },
    where: {
      important
    }
  })

  res.json(notes)
})

The functionality can be further expanded by allowing the user to specify a required keyword when retrieving notes, e.g. a request to http://localhost:3001/api/notes?search=database(opens in a new tab) will return all notes mentioning database or a request to http://localhost:3001/api/notes?search=javascript&important=true(opens in a new tab) will return all notes marked as important and mentioning javascript. The implementation is as follows


router.get('/', async (req, res) => {
  let important = {
    [Op.in]: [true, false]
  }

  if ( req.query.important ) {
    important = req.query.important === "true"
  }

  const notes = await Note.findAll({
    attributes: { exclude: ['userId'] },
    include: {
      model: User,
      attributes: ['name']
    },
    where: {
      important,
      content: {        
        [Op.substring]: req.query.search ? req.query.search : ''      
      }    
    }
  })

  res.json(notes)
})
Sequelize's Op.substring(opens in a new tab) generates the query we want using the LIKE keyword in SQL. For example, if we make a query to http://localhost:3001/api/notes?search=database&important=true(opens in a new tab) we will see that the SQL query it generates is exactly as we expect.


SELECT "note". "id", "note". "content", "note". "important", "note". "date", "user". "id" AS "user.id", "user". "name" AS "user.name"
FROM "notes" AS "note" LEFT OUTER JOIN "users" AS "user" ON "note". "user_id" = "user". "id"
WHERE "note". "important" = true AND "note". "content" LIKE '%database%';
There is still a beautiful flaw in our application that we see if we make a request to http://localhost:3001/api/notes(opens in a new tab), i.e. we want all the notes, our implementation will cause an unnecessary WHERE in the query, which may (depending on the implementation of the database engine) unnecessarily affect the query efficiency:


SELECT "note". "id", "note". "content", "note". "important", "note". "date", "user". "id" AS "user.id", "user". "name" AS "user.name"
FROM "notes" AS "note" LEFT OUTER JOIN "users" AS "user" ON "note". "user_id" = "user". "id"
WHERE "note". "important" IN (true, false) AND "note". "content" LIKE '%%';
Let's optimize the code so that the WHERE conditions are used only if necessary:


router.get('/', async (req, res) => {
  const where = {}

  if (req.query.important) {
    where.important = req.query.important === "true"
  }

  if (req.query.search) {
    where.content = {
      [Op.substring]: req.query.search
    }
  }

  const notes = await Note.findAll({
    attributes: { exclude: ['userId'] },
    include: {
      model: User,
      attributes: ['name']
    },
    where
  })

  res.json(notes)
})
If the request has search conditions e.g. http://localhost:3001/api/notes?search=database&important=true(opens in a new tab), a query containing WHERE is formed


SELECT "note". "id", "note". "content", "note". "important", "note". "date", "user". "id" AS "user.id", "user". "name" AS "user.name"
FROM "notes" AS "note" LEFT OUTER JOIN "users" AS "user" ON "note". "user_id" = "user". "id"
WHERE "note". "important" = true AND "note". "content" LIKE '%database%';
If the request has no search conditions http://localhost:3001/api/notes(opens in a new tab), then the query does not have an unnecessary WHERE


SELECT "note". "id", "note". "content", "note". "important", "note". "date", "user". "id" AS "user.id", "user". "name" AS "user.name"
FROM "notes" AS "note" LEFT OUTER JOIN "users" AS "user" ON "note". "user_id" = "user". "id";

Your implementation is close, but I can see why the peer review might give you 0/1.

Let's compare your code with the exercise requirements.
1. What the exercise requires
There are only two requirements:
1. GET /api/blogs?search=react returns blogs whose title contains react, case-insensitively.
2. GET /api/blogs returns all blogs.
2. Your current implementation
where: {
  title: {
    [Op.substring]: req.query.search ? req.query.search : "",
  },
},


The problem is that Op.substring does not guarantee case-insensitive matching across database systems.

Since you are using PostgreSQL, you should use Op.iLike.
3. Correct implementation
const { Op } = require("sequelize");

router.get("/", async (req, res) => {
  const blogs = await Blog.findAll({
    attributes: { exclude: ["userId"] },
    include: {
      model: User,
      attributes: ["name"],
    },
    where: req.query.search
      ? {
          title: {
            [Op.iLike]: `%${req.query.search}%`,
          },
        }
      : {},
  });

  res.json(blogs);
});


4. Understand the important parts
Op.iLike

PostgreSQL's case-insensitive pattern matching operator.

For example:
[Op.iLike]: "%react%"


Matches:
- React Basics
- Learning REACT
- Introduction to react
- Advanced React Development
Why %?

In SQL pattern matching:
Pattern	Meaning
react	Exact match
%react	Ends with react
react%	Starts with react
%react%	Contains react anywhere

Why use where: {} when there is no search?

An empty where object means no filtering is applied, so all blogs are returned.
5. Test your implementation
Request	Expected result
/api/blogs	All blogs
/api/blogs?search=react	Titles containing react
/api/blogs?search=REACT	Same matching blogs
/api/blogs?search=React	Same matching blogs

Important lesson
Op.substring and Op.iLike are not interchangeable:
- Op.substring: substring matching.
- Op.iLike: case-insensitive pattern matching in PostgreSQL.
My recommendation: Use Op.iLike for this exercise because the instructions explicitly require case-insensitive searching.

Remember this important difference
Operator	Meaning
Op.and	All conditions must match
Op.or	At least one condition must match
Op.substring	Find text containing the search value
Op.in	Match any value in a given list