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