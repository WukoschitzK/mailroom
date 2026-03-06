BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mailroom_user" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "pin" text NOT NULL,
    "role" text NOT NULL
);


--
-- MIGRATION VERSION FOR mailroom_tracker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mailroom_tracker', '20260303145218894', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260303145218894', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
