class AddQuestionsRefToOptions < ActiveRecord::Migration
  def change
    add_reference :options, :questions, index: true
    change_column :options, :questions_id, :integer, :null => false
  end
end
