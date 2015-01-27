namespace :users do
  desc "split user data according to name"
  task :split_user_data_by_name, [:name] => :environment do |rake,args|
    u = User.find_by_name(args[:name])

    #args with default argument
    args.with_defaults(arg1: 'default value')
    puts "default #{args[:arg1]}"

    # variable argumnt
    p args.extras
    p "Passed argument #{args[:name]}" 

  end
end
