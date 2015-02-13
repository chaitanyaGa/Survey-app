class CreateMyscripts < ActiveRecord::Migration
  def change
    create_table :myscripts do |t|

      t.timestamps null: false
    end
  end
end
