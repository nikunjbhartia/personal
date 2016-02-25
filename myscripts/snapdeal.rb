module Crawlers
  class Snapdeal

    def crawl
      divider="\n===============================\n"
      book = Spreadsheet.open 'RRTextiles_SUPC.xls' ; nil
      # book.worksheets.each do |ss|
      ss = book.worksheet 0
      head = ["SUPC","SKU Code","Fulfillment Mode","Product Name","Old Inventory","New Inventory","Live"]
      row = {}
      size = ss.to_a.size
      new_book = Spreadsheet::Workbook.new
      new_book.create_worksheet :name => 'Sheet-1'
      (1..size-1).map do |i|
        begin
          print ".#{i}"
          row = Hash[[head,ss.row(i)].transpose]
          supc =  row["SUPC"]
          rurl = "http://www.snapdeal.com/search?keyword=#{supc}&santizedKeyword=#{supc}&catId=&categoryId=&suggested=false&vertical=p&noOfResults=20&clickSrc=go_header&lastKeyword=#{supc}&prodCatId=&changeBackToAll=false&foundInAll=false&categoryIdSearched=&cityPageUrl=&url=&utmContent=&dealDetail="
          ragent = Mechanize.new
          ragent.redirect_ok = false
          rpage = ragent.get(rurl)
          hurl = rpage.search(".hoverProductWrapper > a:nth-child(1)").first.attr("href")
          agent = Mechanize.new
          page = agent.get(hurl)
          name = row["Product Name"]
          img = page.search("#bx-slider-left-image-panel > li:nth-child(1) > img:nth-child(1)").first.attr("src")
          price = page.search(".payBlkBig").first.text.squish.tr(",","") rescue nil
          desc = page.search("div.spec-section:nth-child(1) > div:nth-child(2)").first.text.squish rescue nil
          row1 = [name,price,img,desc]
          new_book.worksheet(0).insert_row(i,row1)
          rescue Exception => e
          puts "failed #{i}"
          File.open("snap_supcRR", 'a') { |file|
            file << supc
            file << " : #{$!}\n"
          }
        end
      end
      new_book.write('RRT_snap_supc.xls')
    end
  end
end
