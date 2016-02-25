  include ApiWriter
  book = Spreadsheet.open 'collection_data.xls' ; nil 
  ss = book.worksheet 0
  head = ["collection_id","product_id","name","user_id","lastseen_at"]
  size = ss.to_a.size
  hsh={}
            (501..size-1).each do |i|            
                print ".#{i}"
                row = Hash[[head,ss.row(i)].transpose]
                hsh[:collectionIds] = [row["collection_id"]]
                hsh[:productIds] = [row["product_id"]]
                write_api("put",'/products/bulk-update',hsh.to_json,"response")
             end

