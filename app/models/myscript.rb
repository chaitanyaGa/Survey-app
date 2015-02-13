class Myscript < ActiveRecord::Base
  def self.save(upload)
    b = File.new('/home/chaitanya/survey-app/public/captur.jpg','w+b')
    b.write(upload.read)
    b.close
  #  directory = "public/data"
    # create the file path
   # path = File.join(directory, name)
    # write the file
   # File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end
end
