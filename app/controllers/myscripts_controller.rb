class MyscriptsController < ApplicationController
  def save()
    post =  Myscript.save( params[:webcam].tempfile);
    puts '+++++++++++++++++++++********************************************'
    #p = File.new('/home/chaitanya/survey-app/tmp/*.jpg','rb')
    #b = File.new('/home/chaitanya/survey-app/public/captur.jpg','wb')
    #p.each do |line|
     # b.write(line)
    #end
    #b.close
    #p.close
    #puts params["authenticity_token"];
    puts '__________________________________________________________'
    puts post
    redirect_to new_sessions_path
    # name =  upload['datafile'].original_filename
    # directory = "public/data"
    # create the file path
    # path = File.join(directory, name)
    # write the file
    # File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

end
