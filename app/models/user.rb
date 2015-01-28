class User < ActiveRecord::Base
  # validations
  validates_presence_of :gender
  validates :gender, inclusion: { in: %w(M F), message: "%{value} is not value"}
  validates_presence_of :age 
  validates_numericality_of :age,:greater_than => 18, :less_than_or_equal_to => 40, :only_integer => true


  # associations
  belongs_to :role
  has_many :responses
  has_many :options, through: :response


  # callbacks
  before_save :name_capital

  private

  def name_capital
    puts "Name is capitalize:"
    self.name =  name.downcase.titleize
  end

  #write block
end
