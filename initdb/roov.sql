CREATE TYPE "user_type" AS ENUM (
  'official',
  'regular',
  'admin'
);

CREATE TYPE "follows_type" AS ENUM (
  'user'
);

CREATE TYPE "votes_type" AS ENUM (
  'comment',
  'album',
  'audio',
  'radio',
  'news',
  'video'
);

CREATE TYPE "comments_type" AS ENUM (
  'comment',
  'album',
  'audio',
  'radio',
  'news',
  'video'
);

CREATE TYPE "object_type" AS ENUM (
  'radio',
  'album',
  'news',
  'video'
);

CREATE TYPE "media_type" AS ENUM (
  'banner',
  'cover',
  'avatar'
);

CREATE TYPE "album_type" AS ENUM (
  'podcast',
  'spiritual',
  'cerita_suara'
);

CREATE TYPE "moderation_status" AS ENUM (
  'published',
  'in_moderation',
  'rejected'
);

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "username" varchar UNIQUE NOT NULL,
  "password" varchar,
  "type" user_type,
  "active" bool,
  "verified" bool,
  "sso_id" varchar UNIQUE NOT NULL,
  "facebook_id" varchar UNIQUE,
  "google_id" varchar UNIQUE,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "follows" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int NOT NULL,
  "following_id" int NOT NULL,
  "type" follows_type,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "votes" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int NOT NULL,
  "object_id" int NOT NULL,
  "type" votes_type,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "comments" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int,
  "object_id" int NOT NULL,
  "type" comments_type,
  "message" varchar,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "sessions" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int NOT NULL,
  "key" varchar UNIQUE NOT NULL,
  "push_notif_token" varchar,
  "device" varchar,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "categories" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "slug" varchar UNIQUE NOT NULL,
  "parent_id" int,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "categories_having_relation" (
  "category_id" int,
  "object_type" varchar,
  "object_id" int
);

CREATE TABLE "media" (
  "id" SERIAL PRIMARY KEY,
  "url" varchar NOT NULL,
  "object_id" int,
  "object_type" object_type,
  "type" media_type,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "locations" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE INDEX idx_locations_name ON locations(name);

CREATE TABLE "radios" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "url" varchar NOT NULL,
  "slug" varchar UNIQUE NOT NULL,
  "is_music" bool,
  "description" varchar,
  "user_id" int,
  "location_id" int,
  "weight" int DEFAULT 100,
  "total_play" int,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "album" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "description" varchar,
  "slug" varchar UNIQUE NOT NULL,
  "type" album_type,
  "weight" int DEFAULT 100,
  "user_id" int,
  "active" bool,
  "moderation_status" moderation_status,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "audios" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "duration" int,
  "description" varchar,
  "url" varchar,
  "album_id" int,
  "total_play" int,
  "active" bool,
  "slug" varchar UNIQUE NOT NULL,
  "moderation_status" moderation_status,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "news" (
  "id" SERIAL PRIMARY KEY,
  "slug" varchar UNIQUE NOT NULL,
  "title" varchar NOT NULL,
  "excerpt" varchar NOT NULL,
  "body" varchar NOT NULL,
  "user_id" int,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "videos" (
  "id" SERIAL PRIMARY KEY,
  "title" varchar NOT NULL,
  "slug" varchar UNIQUE NOT NULL,
  "description" varchar NOT NULL,
  "url" varchar NOT NULL,
  "user_id" int,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "backsounds" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "description" varchar,
  "duration" int NOT NULL,
  "url" varchar NOT NULL,
  "active" bool,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE "static" (
  "id" SERIAL PRIMARY KEY,
  "key" varchar NOT NULL,
  "value" varchar,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

ALTER TABLE "follows" ADD CONSTRAINT "follows_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "votes" ADD CONSTRAINT "votes_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "comments" ADD CONSTRAINT "comments_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "sessions" ADD CONSTRAINT "sessions_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "categories" ADD CONSTRAINT "categories_parent" FOREIGN KEY ("parent_id") REFERENCES "categories" ("id");

ALTER TABLE "radios" ADD CONSTRAINT "radios_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "radios" ADD CONSTRAINT "radios_locations" FOREIGN KEY ("location_id") REFERENCES "locations" ("id");

ALTER TABLE "album" ADD CONSTRAINT "album_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "audios" ADD CONSTRAINT "audios_album" FOREIGN KEY ("album_id") REFERENCES "album" ("id");

ALTER TABLE "news" ADD CONSTRAINT "news_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "videos" ADD CONSTRAINT "videos_users" FOREIGN KEY ("user_id") REFERENCES "users" ("id");
