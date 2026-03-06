BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "dispatch_lists" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "employees" ADD COLUMN "nfcTagId" text;
ALTER TABLE "employees" ADD COLUMN "substituteId" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "shipments" (
    "id" bigserial PRIMARY KEY,
    "identifier" text NOT NULL,
    "direction" text NOT NULL,
    "type" text NOT NULL,
    "status" text NOT NULL,
    "weight" double precision,
    "trackingNumber" text,
    "recipientText" text,
    "recipientId" bigint,
    "isDamaged" boolean NOT NULL,
    "imageUrl" text NOT NULL,
    "damagePhotoUrl" text,
    "signatureImageUrl" text,
    "scannedAt" timestamp without time zone NOT NULL,
    "slaDeadline" timestamp without time zone,
    "deliveredAt" timestamp without time zone,
    "proofOfDelivery" text,
    "dispatchListId" bigint
);


--
-- MIGRATION VERSION FOR mailroom_tracker
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mailroom_tracker', '20260302122814645', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260302122814645', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
