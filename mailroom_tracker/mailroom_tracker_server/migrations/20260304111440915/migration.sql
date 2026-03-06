BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "shipment" ADD COLUMN "auditLog" text;

--
-- MIGRATION VERSION FOR mailroom_tracker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mailroom_tracker', '20260304111440915', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260304111440915', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
