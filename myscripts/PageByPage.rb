#Page By Page -  scrap images from url

ss = Roo::Excelx.new("/Users/senthil.kumar/Downloads/pbp.xlsx")
head = ss.row(1)
(2..ss.last_row).map do |i| 
begin
  print "."
  print i if i % 100
  row = Hash[[head,ss.row(i)].transpose]
  url =  row["image"]
  agent = Mechanize.new
  page = agent.get(url)
  search_obj = page.search("div.product-images // a // img")
  if search_obj.blank?
    puts "no book found in the url - #{i}"
  else
    img_url = search_obj.first.attr("src").gsub(/small/,"large") 
  end
  out =  "#{row["image"]} | http://pagebypage.in/#{img_url}"
  File.open("page_by_page.out", 'a') { |file| file.puts(out) }
  rescue 
    puts "failed #{i}"
  end
end 