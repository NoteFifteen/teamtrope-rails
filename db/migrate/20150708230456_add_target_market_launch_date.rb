class AddTargetMarketLaunchDate < ActiveRecord::Migration

  # Task 617 - Adding Target Market Launch Date columns
  def change
    add_column :projects, :target_market_launch_date, :date
  end
end
