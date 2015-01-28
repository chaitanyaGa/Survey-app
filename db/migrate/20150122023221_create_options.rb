class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :option, null: false
      t.references :question
      t.timestamps null: false
    end
  end
end
