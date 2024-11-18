class AddSoftDeleteToSleepRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :sleep_records, :deleted_at, :datetime
    add_index :sleep_records, :deleted_at
  end
end
