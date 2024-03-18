# frozen_string_literal: true

class UpdateAttendancePointsOnEventChange < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
  CREATE OR REPLACE FUNCTION update_attendance_points()
  RETURNS TRIGGER AS $$
  BEGIN
    IF NEW."eventPoints" IS DISTINCT FROM OLD."eventPoints" THEN
      UPDATE attendances
      SET "pointsAwarded" = NEW."eventPoints"
      WHERE "eventID" = NEW.id;
    END IF;
    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;
    SQL

    execute <<-SQL
  CREATE TRIGGER update_attendance_points_after_event_update
  AFTER UPDATE OF "eventPoints" ON events
  FOR EACH ROW
  EXECUTE FUNCTION update_attendance_points();
    SQL
  end

  def down
    execute 'DROP TRIGGER IF EXISTS update_attendance_points_after_event_update ON events;'
    execute 'DROP FUNCTION IF EXISTS update_attendance_points;'
  end
end
