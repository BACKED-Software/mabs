class AddAttendanceAndEventTriggers < ActiveRecord::Migration[7.0]
  def up
    # Add the SQL commands to create triggers and functions here
    # Create a function to update total points based on attendance
    execute <<-SQL
    CREATE OR REPLACE FUNCTION update_user_total_points_from_attendance()
    RETURNS TRIGGER AS $$
    BEGIN
      UPDATE users
      SET total_points = (
        SELECT SUM("numPointsAwarded")
        FROM points
        WHERE "awardedTo" = NEW."googleUserID"
      ) + (
        SELECT SUM("pointsAwarded")
        FROM attendances
        WHERE "googleUserID" = NEW."googleUserID"
      )
      WHERE "uid" = NEW."googleUserID";
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
  SQL

    # Create a trigger for INSERT on attendances
    execute <<-SQL
    CREATE TRIGGER update_points_after_attendance
    AFTER INSERT ON attendances
    FOR EACH ROW
    EXECUTE FUNCTION update_user_total_points_from_attendance();
  SQL

    # Create a function to update total points when event points change
    execute <<-SQL
    CREATE OR REPLACE FUNCTION update_user_points_from_event_change()
    RETURNS TRIGGER AS $$
    BEGIN
      UPDATE users
      SET total_points = (
        SELECT SUM("numPointsAwarded")
        FROM points
        WHERE "awardedTo" = users."uid"
      ) + (
        SELECT SUM("pointsAwarded")
        FROM attendances
        WHERE "googleUserID" = users."uid"
      )
      WHERE "uid" IN (
        SELECT "googleUserID"
        FROM attendances
        WHERE "eventID" = NEW."id"
      );
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
  SQL

    # Create a trigger for UPDATE on events
    execute <<-SQL
    CREATE TRIGGER update_points_after_event_update
    AFTER UPDATE ON events
    FOR EACH ROW
    WHEN (OLD."eventPoints" IS DISTINCT FROM NEW."eventPoints")
    EXECUTE FUNCTION update_user_points_from_event_change();
  SQL

    # Add the other triggers and functions similarly
  end

  def down
    # Add the SQL commands to drop the triggers and functions here
    execute "DROP TRIGGER IF EXISTS update_points_after_event_update ON events;"
    execute "DROP FUNCTION IF EXISTS update_user_points_from_event_change;"
    execute "DROP TRIGGER IF EXISTS update_points_after_attendance ON attendances;"
    execute "DROP FUNCTION IF EXISTS update_user_total_points_from_attendance;"
    # Drop the other triggers and functions similarly
  end
end
