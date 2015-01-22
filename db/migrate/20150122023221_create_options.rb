class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :options, null: false
      t.timestamps null: false
    end
  end
end
