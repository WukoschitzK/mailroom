BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "shipments" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shipment" (
    "id" bigserial PRIMARY KEY,
    "identifier" text NOT NULL,
    "direction" text NOT NULL,
    "type" text NOT NULL,
    "status" text NOT NULL,
    "trackingNumber" text,
    "recipientText" text,
    "recipientId" bigint,
    "isDamaged" boolean NOT NULL,
    "imageUrl" text NOT NULL,
    "signatureImageUrl" text,
    "scannedAt" timestamp without time zone NOT NULL,
    "deliveredAt" timestamp without time zone,
    "note" text,
    "createdBy" text,
    "deliveredBy" text
);


--
-- MIGRATION VERSION FOR mailroom_tracker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mailroom_tracker', '20260303132940706', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260303132940706', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
