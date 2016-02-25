
require 'mechanize'
require 'action_view'
require 'spreadsheet'
include ActionView::Helpers::NumberHelper

book = Spreadsheet.open 'ProductsTop100.xls' ; nil 
ss = book.worksheet 0
size = ss.to_a.size

new_book = Spreadsheet::Workbook.new
new_book.create_worksheet :name => 'Production100'
accept = {}
accept["Windows Chrome"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
accept["Firefox"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
accept["Android"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
accept["iPhone"] = "image/*;q=0.8"
txs = ["",    
    "/f_auto,fl_lossy,q_50,e_saturation:40/e_contrast:40",
    "/f_auto,fl_lossy,q_50,e_saturation:28/e_contrast:28",
    "/f_auto,fl_lossy,q_50,e_saturation:40",
    "/f_auto,fl_lossy,q_50,e_saturation:28",
    "/f_auto,fl_lossy,q_50,e_contrast:40",
    "/f_auto,fl_lossy,q_50,e_contrast:28",
    "/f_auto,fl_lossy,e_improve,q_50",
    "/f_auto,fl_lossy,q_50",
     ]
row = ["Image","transformation","image-size","type"]
new_book.worksheet(0).insert_row(0,row)
agent = Mechanize.new
# agent.user_agent_alias="Windows Chrome"
head = ["Image"]

platform = ["Windows Chrome","Linux FireFox","Android","iPhone"]
plat="Windows Chrome"
c = 1
(1..size-1).each do |i|
    print ".#{i}"
    row = Hash[[head,ss.row(i)].transpose]
    uri = row["Image"]
    str = uri.split(/upload/)
    str[0] = str[0]+"upload"
 
# platform.each do |plat|
    agent.user_agent_alias = plat
    txs.each do |t|
        url = str[0]+t+str[1]
        resp = agent.head url,nil,{'Accept' => accept[plat]}
        a = resp["content-length"].to_i
        type = resp["content-type"]
        kb = number_to_human_size(a)
        t = "Original" if t==""
        link = Spreadsheet::Link.new(url,url)
        row = [link,t,kb,type]
        new_book.worksheet(0).insert_row(c,row)
        c+=1
    end
     row = [" "]
     new_book.worksheet(0).insert_row(c,row)
     c+=1
     row = ["Image #{i+1}"]
     new_book.worksheet(0).insert_row(c,row)
     c+=1
end
  

new_book.write('ResultProductsTop100.xls')

