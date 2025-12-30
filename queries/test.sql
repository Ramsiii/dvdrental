-- List all existing Triggers:

SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';

-- Disable Trigger

-- ALTER TABLE detailed_rentals DISABLE TRIGGER trg_update_summary;

-- List all existing Triggers:

-- SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';

-- Re-Enable Trigger after re-populating table
-- ALTER TABLE detailed_rentals ENABLE TRIGGER trg_update_summary;

-- List all existing Triggers:

-- SELECT * FROM pg_trigger WHERE tgname LIKE 'trg_%';