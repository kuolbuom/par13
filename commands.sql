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