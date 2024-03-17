class UpdateUserTotalPointsFunction < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION update_user_total_points()
      RETURNS TRIGGER AS $$
      BEGIN
        UPDATE users
        SET total_points = (
          SELECT SUM("numPointsAwarded")
          FROM points
          WHERE "awardedTo" = NEW."awardedTo"
        ) + (
          SELECT COALESCE(SUM("pointsAwarded"), 0)
          FROM attendances
          WHERE "googleUserID" = NEW."awardedTo"
        )
        WHERE "uid" = NEW."awardedTo";
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL


  end

  def down
  end
end
