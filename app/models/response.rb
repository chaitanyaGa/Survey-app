class Response < ActiveRecord::Base
  belongs_to :option
  validates_uniqueness_of :option_id, :scope => :user_id #unique for user_id
  belongs_to :user
end
