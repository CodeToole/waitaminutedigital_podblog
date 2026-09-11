BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "article" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "slug" text NOT NULL,
    "summary" text NOT NULL,
    "body" text NOT NULL,
    "badge" text NOT NULL,
    "coverImageUrl" text,
    "youtubeUrl" text,
    "isPublished" boolean NOT NULL DEFAULT false,
    "publishedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "article_slug_unique_idx" ON "article" USING btree ("slug");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lead_inquiry" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "projectType" text NOT NULL,
    "message" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "project_highlight" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "client" text NOT NULL,
    "summary" text NOT NULL,
    "coverImageUrl" text,
    "externalUrl" text,
    "isFeatured" boolean NOT NULL DEFAULT false,
    "order" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE INDEX "project_highlight_featured_idx" ON "project_highlight" USING btree ("isFeatured");


--
-- MIGRATION VERSION FOR waitaminute_serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('waitaminute_serverpod', '20260906145000292', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260906145000292', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
