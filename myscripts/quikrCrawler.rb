require 'json'
require 'faraday'

conn = Faraday.new 'http://captcha.quikr.com/cg_js/ajaxCity.php?r=0.6747898619310855'
response = conn.get
str = response.body[33..-3]
hsh = JSON.parse(str)
cities = hsh.to_a
c_size = cities.size


open('Locations', 'a') { |f|
conn = Faraday.new(:url => 'http://www.quikr.com')
(0..c_size-1).each do |i|
 response = conn.post '/post-classifieds-ads/?aj=1&aj_getLocality=true', { :cityname => cities[i][1]["en"] }
 str = response.body[12..-233]
 if(str[-1] == '}')
   str = str+']'
 end
 localities = JSON.parse(str)
 l_size = localities.size
 if l_size == 0
  f<<(cities[i][1]["en"]+" | Entire "+cities[i][1]["en"]+"\n")
 else  
   (0..l_size-1).each do |j|
   f<<(cities[i][1]["en"]+" | "+localities[j]["title"]+"\n")
    end
 end 
end
}
