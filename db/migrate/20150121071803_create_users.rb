class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :age
      t.string :gender
      t.references :role
      t.timestamps null: false
      t.string :username
      t.string :password
    end
  end
end
