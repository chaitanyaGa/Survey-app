class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :option
      t.references :user
      t.timestamps null: false
    end
  end
end
