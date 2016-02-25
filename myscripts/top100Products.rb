 # mina production deploy
 
a=Product.order("view_count DESC").limit(100).map{|i| i.id}
i=[]
a.each do |k|
i << Image.where(product_id: k).first["original"]
end
new_book = Spreadsheet::Workbook.new
new_book.create_worksheet :name => 'Top100'
new_book.worksheet(0).insert_row(0,["Image"])

i.each_with_index do |f,index|
	new_book.worksheet(0).insert_row(index+1,[f])
end
new_book.write('ProductsTop100.xls')



=======================================================
# Reading 100 urls and testing with differenet transformations 

require 'mechanize'
require 'action_view'
require 'spreadsheet'
include ActionView::Helpers::NumberHelper

book = Spreadsheet.open 'ProductsTop100.xls' ; nil 
ss = book.worksheet 0
size = ss.to_a.size

new_book = Spreadsheet::Workbook.new
new_book.create_worksheet :name => 'Production100'
accept={}
accept["Windows Chrome"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
accept["Firefox"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
accept["Android"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
accept["iPhone"] = "image/*;q=0.8"
txs =["",
	  "/f_auto,fl_lossy,e_improve,q_50",
	  "/f_auto,fl_lossy,q_50,e_contrast:40,e_saturation:40",
      "/f_auto,fl_lossy,q_50,e_contrast:28,e_saturation:28",
	  "/f_auto,fl_lossy,q_60,e_contrast:40,e_saturation:40",
	  "/f_auto,fl_lossy,q_70,e_contrast:40,e_saturation:40",
	  "/fl_lossy,f_auto,q_50,e_contrast,e_saturation"	  
	 ]
row=["Image","transformation","Platform","image-size","type"]
new_book.worksheet(0).insert_row(0,row)
agent=Mechanize.new
# agent.user_agent_alias="Windows Chrome"
head=["Image"]

platform=["Windows Chrome","Linux FireFox","Android","iPhone"]
c=1
(1..size-1).each do |i|
    print ".#{i}"
    row = Hash[[head,ss.row(i)].transpose]
    uri = row["Image"]
    str = uri.split(/upload/)
    str[0]=str[0]+"upload"
 
platform.each do |plat|
    agent.user_agent_alias=plat
    txs.each do |t|
        url=str[0]+t+str[1]
        resp=agent.head url,nil,{'Accept' => accept[plat]}
        a=resp["content-length"].to_i
        type=resp["content-type"]
        kb=number_to_human_size(a)
        t="Original" if t==""
        link=Spreadsheet::Link.new(url,url)
        row=[link,t,plat,kb,type]
        new_book.worksheet(0).insert_row(c,row)
        c+=1
    end
    row=[" "]
     new_book.worksheet(0).insert_row(c,row)
     c+=1
  end
  row=[" "]
  new_book.worksheet(0).insert_row(c,row)
  c+=1
  row=["Image #{i+1}"]
  new_book.worksheet(0).insert_row(c,row)
  c+=1
end

new_book.write('ResultProductsTop100.xls')


# ========Size==============
require 'Machanize'
require 'action_view'
include ActionView::Helpers::NumberHelper
uri="http://res.cloudinary.com/dq8ftqelw/image/upload/fl_lossy,q_70,f_auto,e_contrast,e_saturation/v1442911940/5.2MB_ml6dub.jpg"
 a=Mechanize.new.head(uri)["content-length"].to_i
 number_to_human_size(a)

 uri="http://res.cloudinary.com/dq8ftqelw/image/upload/fl_lossy,q_60,f_auto,e_contrast,e_saturation/v1442911940/5.2MB_ml6dub.jpg"
 a=Mechanize.new.head(uri)["content-length"].to_i
 number_to_human_size(a)

 uri="http://res.cloudinary.com/dq8ftqelw/image/upload/fl_lossy,q_100,f_auto,e_contrast,e_saturation/v1442911940/5.2MB_ml6dub.jpg"
 a=Mechanize.new.head(uri)["content-length"].to_i
 number_to_human_size(a)


#  ==============================
#  uri="http://res.cloudinary.com/dq8ftqelw/image/upload/fl_lossy,q_70,f_auto,e_contrast,e_saturation/v1442911940/5.2MB_ml6dub.jpg"
# image=MiniMagick::Image.open(uri)
# number_to_human_size(image.size)


======Request Header form Chrome :
'User-Agent' => "Mozilla/5.0 (Linux; U; en-us; KFAPWI Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Silk/3.13 Safari/535.19 Silk-Accelerated=true"

====Request header form firefox : 
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0

=========================
INNER JOIN @active_products p
ON p.user_id = User.id
where('users.status = "VERIFIED"')



joins("INNER JOIN @my p
ON p.user_id = users.id").
where('users.status = "VERIFIED"')