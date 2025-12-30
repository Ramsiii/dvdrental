-- Disable Trigger before re-populating table

ALTER TABLE detailed_rentals DISABLE TRIGGER trg_update_summary;

-- Execute Procedure manually:

CALL refresh_rental_analysis();

-- Re-Enable Trigger after re-populating table
ALTER TABLE detailed_rentals ENABLE TRIGGER trg_update_summary;