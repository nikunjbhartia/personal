module Crawlers
  class Snapdeal

  def crawl
    divider="\n===============================\n"
            book = Spreadsheet.open 'om_computronix_SnapdealSUPC.xls' ; nil  
        # book.worksheets.each do |ss|        
            ss = book.worksheet 0
            head=["SUPC"]
            row={}
            size=ss.to_a.size
            new_book = Spreadsheet::Workbook.new
            new_book.create_worksheet :name => 'Sheet-1'
            row1=["Name","Price","Image","Desc"]
            new_book.worksheet(0).insert_row(0,row1)
            (1..size).map do |i|
                begin
                    print ".#{i}"
                    row = Hash[[head,ss.row(i)].transpose]
                    supc =  row["SUPC"]
                    rurl = "http://www.snapdeal.com/search?keyword=#{supc}&santizedKeyword=&catId=&categoryId=&suggested=false&vertical=&noOfResults=20&clickSrc=go_header&lastKeyword=&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&url=&utmContent=&dealDetail="   
                    ragent = Mechanize.new
                    rpage = ragent.get(rurl)
                    
                    hurl = rpage.search(".hoverProductWrapper > a:nth-child(1)").first.attr("href")
          
                    page = ragent.get(hurl)
                     name = page.search(".pdp-e-i-head").first.text
                     img = page.search("#bx-slider-left-image-panel > li:nth-child(1) > img:nth-child(1)").first.attr("src") 
                     price = page.search(".payBlkBig").first.text.squish.tr(",","") rescue nil    
                     desc = page.search("div.spec-section:nth-child(2) > div:nth-child(2)").first.text.squish rescue nil          
                     row1=[name,price,img,desc]
                     new_book.worksheet(0).insert_row(i,row1)
                     # out = divider+"#{isbn}|#{img}|#{desc}"+divider
                     # File.open("one_buy_20k_flip.out", 'a') { |file| file << out}
                     rescue
                     puts "failed #{i}"
                     File.open("snap_supc.err", 'a') { |file| file.puts(supc) }
                end
             end
             new_book.write('om_supc2.xls')
             
      # end
    end
  end
end