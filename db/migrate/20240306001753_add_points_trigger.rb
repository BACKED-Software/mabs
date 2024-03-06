class AddPointsTrigger < ActiveRecord::Migration[7.0]
  def up
    # Create a function to calculate total points
    execute <<-SQL
      CREATE OR REPLACE FUNCTION update_user_total_points()
      RETURNS TRIGGER AS $$
      BEGIN
        UPDATE users
        SET total_points = (
          SELECT SUM("numPointsAwarded")
          FROM points
          WHERE "awardedTo" = NEW."awardedTo"
        )
        WHERE "uid" = NEW."awardedTo";
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    # Create a trigger for INSERT OR UPDATE
    execute <<-SQL
      CREATE TRIGGER update_points_after_insert_or_update
      AFTER INSERT OR UPDATE ON points
      FOR EACH ROW
      EXECUTE FUNCTION update_user_total_points();
    SQL

    # Create a trigger for DELETE
    execute <<-SQL
      CREATE TRIGGER update_points_after_delete
      AFTER DELETE ON points
      FOR EACH ROW
      EXECUTE FUNCTION update_user_total_points();
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS update_points_after_insert_or_update ON points;"
    execute "DROP TRIGGER IF EXISTS update_points_after_delete ON points;"
    execute "DROP FUNCTION IF EXISTS update_user_total_points;"
  end
end
