desc "Split user data by id"

task :split_user_data_by_id, [:id] => :environment do |task,arg|
  u = User.find(arg[:id])
  name_array = u.name.split(" ")
  p "first name: #{name_array[0]} last name: #{name_array[1]}"
end
  
