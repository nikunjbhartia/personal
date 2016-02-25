require 'mechanize'
require 'action_view'
require 'spreadsheet'
include ActionView::Helpers::NumberHelper

a=Product.order("view_count DESC").limit(10).map{|i| i.id}
images=[]
a.each do |k|
  images << Image.where(product_id: k).first["original"]
end

new_book = Spreadsheet::Workbook.new
new_book.create_worksheet :name => 'Production'

accept = {}
accept["Windows Chrome"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
accept["Firefox"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
accept["Android"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
accept["iPhone"] = "image/*;q=0.8"

txs = ["",
       "/f_auto,fl_lossy,e_improve,q_50",
       "/f_auto,fl_lossy,q_50,e_contrast:40,e_saturation:40",
       "/f_auto,fl_lossy,q_50,e_contrast:28,e_saturation:28",
       "/f_auto,fl_lossy,q_60,e_contrast:40,e_saturation:40",
       "/f_auto,fl_lossy,q_70,e_contrast:40,e_saturation:40",
       "/fl_lossy,f_auto,q_50,e_contrast,e_saturation"   
      ]

row = ["Image","transformation","Platform","image-size","type"]
new_book.worksheet(0).insert_row(0,row)
agent = Mechanize.new

platform = ["Windows Chrome","Linux FireFox","Android","iPhone"]
c = 1

images.each_with_index do |uri,i|
	p ".#{i}"
	str = uri.split(/upload/)
    str[0] = str[0]+"upload"
 
    platform.each do |plat|
        agent.user_agent_alias = plat
        txs.each do |t|
           url = str[0]+t+str[1]
           resp = agent.head url,nil,{'Accept' => accept[plat]}
           a = resp["content-length"].to_i
           type = resp["content-type"]
           kb = number_to_human_size(a)
           t = "Original" if t==""
           link = Spreadsheet::Link.new(url,url)
           row = [link,t,plat,kb,type]
           new_book.worksheet(0).insert_row(c,row)
           c += 1
        end
        row=[" "]
        new_book.worksheet(0).insert_row(c,row)
        c += 1
    end
    row = [" "]
    new_book.worksheet(0).insert_row(c,row)
    c += 1
    row = ["Image #{i+1}"]
    new_book.worksheet(0).insert_row(c,row)
    c += 1
end

new_book.write('ResultProductsTop100.xls')


