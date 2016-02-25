#Smartshopar Crawler
ss = Roo::Excelx.new("/Users/senthil.kumar/Downloads/pbp.xlsx")
head = ss.row(1)

      (2..ss.last_row).map do |i| 
       begin
        print "."
        print i if i % 100
        row = Hash[[head,ss.row(i)].transpose]
        url = "http://www.smartshophar.com"  + row["image"]
        agent = Mechanize.new
        page = agent.get(url)
        img_urls = page.search("div#catalog-images // a // img").map {|i| i.attr("src").gsub(/45x45/,"600x600") }.join(",")
        out =  "#{row["url"]} | #{img_urls}"
        File.open("smartshophar.out", 'a') { |file| file.puts(out) }
        rescue 
          puts "failed #{i}"
        end
      end 