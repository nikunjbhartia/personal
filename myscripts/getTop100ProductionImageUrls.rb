 
# in production environment load this rb file and it will create an xls file with urls of top 100 
# products in rpoduction based on their view count

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


