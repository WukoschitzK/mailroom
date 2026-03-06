BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "mailroom_user" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mailroom_user" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "pin" text NOT NULL,
    "role" text NOT NULL,
    "location" text NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "shipment" ADD COLUMN "storageLocation" text;

--
-- MIGRATION VERSION FOR mailroom_tracker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mailroom_tracker', '20260304103459514', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260304103459514', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
