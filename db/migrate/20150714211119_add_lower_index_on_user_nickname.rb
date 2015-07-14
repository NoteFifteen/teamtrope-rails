class AddLowerIndexOnUserNickname < ActiveRecord::Migration
  def up
      execute <<-SQL
        CREATE INDEX users_lower_nickname_idx ON users ((lower(nickname)));
      SQL
  end

  def down
      execute <<-SQL
        DROP INDEX IF EXISTS users_lower_nickname_idx;
      SQL
  end
end
