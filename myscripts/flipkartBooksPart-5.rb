        require 'spreadsheet'
        require 'mechanize'
        book = Spreadsheet.open 'Shopo part-5.xls' ; nil  
        ss = book.worksheet 1
        head=["ISBN-13" ,"ISBN-10", "Book Code" ,"Onebuy Reference No", "Title", "Publisher", "Author" , "Currency" , "Price", "MRP", "Available Quantity"]
        row=["ISBN","Title","Desc","Price","Img"]
        size=ss.to_a.size
        new_book = Spreadsheet::Workbook.new
        new_book.create_worksheet :name => 'PART-5'
        new_book.worksheet(0).insert_row(0,row)
        (6505..8625).each do |i|
            begin
                print ".#{i}"
                row = Hash[[head,ss.row(i)].transpose]
                isbn =  row["ISBN-13"].to_i 
                title = row["Title"].to_s
                price= row["Price"].to_i         
                rurl = "http://www.flipkart.com/search?q=#{isbn}&as=off&as-show=off&otracker=start"  
                ragent = Mechanize.new
                ragent.redirect_ok = false
                rpage = ragent.get(rurl)                 
                hurl = rpage.header["location"]
                agent = Mechanize.new
                url = "http://www.flipkart.com#{hurl}"
                page = agent.get(url)                 
                 img = page.search("div.top-section // div.productImages // div.mainImage // div.imgWrapper").first.children[1].attributes["data-src"].value         
                 desc = page.search("div.description // div.description-text").first.text.squish rescue nil          
                 row1=[isbn,title,desc,price,img]
                 new_book.worksheet(0).insert_row(i,row1)
                
                 rescue
                 puts "failed #{i}"
                 File.open("one_buy_20k_flip2.err", 'a') { |file| file.puts(isbn) }
            end
         end
         new_book.write('Shopo part-5_complete2.xls')