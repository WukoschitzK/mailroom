BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "employees" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "department" text NOT NULL,
    "isAbsent" boolean NOT NULL
);


--
-- MIGRATION VERSION FOR mailroom_tracker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mailroom_tracker', '20260302121401728', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260302121401728', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
