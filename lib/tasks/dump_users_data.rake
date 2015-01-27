desc "dumps the user data"

task :dump_users_data, [:id] => :environment do |task, args, p|
  p task
  p args
  p p
  puts "hi i am inside rake task"
  (1..User.count).each do |id|
    u = User.find_by(id: id)
    name = u.name.split(" ")
    print "name: #{name[0]}  "
    print "surname: "
    puts name[1]
  end
end
