#Download Image from Dropbox to local machine upload to cloudinary (pId,cloudinaryImageUrl1,cloudinaryImageUrl2,cloudinaryImageUrl3)
def upload_url(agent,url)
  if !url.blank?
	  img_url = url.gsub('dl=0','dl=1')
	  uri = URI img_url
	  file = agent.get(uri) 
	  file_name = file.save
	  cloud_url = Cloudinary::Uploader.upload(file_name)
	  cloud_url["url"]
  else
      nil
  end
end


require 'mechanize'
ss = Roo::Excelx.new("/Users/bhardwaj.akash/Downloads/dropbox.xlsx")
head = ss.row(1)
      (282..ss.last_row).map do |i| 
      	begin
       
        print "."
        print i if i % 100
        row = Hash[[head,ss.row(i)].transpose]
        pid = row["Product ID"]
        url1 = row["Main Image URL"]
        url2 = row["Other Image URL1"]
        url3 = row["Other Image URL2"]
        agent = Mechanize.new
        urls = []
        %w(url1 url2 url3).each do |u|
          urls << upload_url(agent,eval(u))
        end
        urls = urls.compact.join(",")

        str = "#{pid},#{urls}"
        File.open("/Users/bhardwaj.akash/Downloads/dropout.txt", 'a') { |file| file.puts(str) }
        rescue
          puts "failed #{i}"
        end
      end 