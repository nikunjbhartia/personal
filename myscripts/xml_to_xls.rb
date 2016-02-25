
# <ProductResult>
#     <itemId>6348</itemId>
#     <Categoryid>OFFER CATEGORY</Categoryid>
#     <Subcategoryname>OFFER CATEGORY</Subcategoryname>
#     <ProductName>Festive Beauty - H1511</ProductName>
#     <itemCode>H1511OFFER</itemCode>
#     <Productweight>0</Productweight>
#     <ListPrice>1999</ListPrice>
#     <imageTag>http://www.suratdiamond.com/HamperProduct_Images/H1511PS95.jpg</imageTag>
#     <shortDescription>A dazzling red  green kundan Necklace Earring Set . Necklace Length 5.50  extendable Cheddia Earring Height 1.50Peacock Necklace Earring Set. Necklace Length 16 Pendant Height 2.50 with Hook Earring Height 2.00Flower Shaped Golden Jhumki Earrings. Earring Wt 22.00 gms Dimension 5.00 x 2.50 cmsRed  White Kundan Polki Goddess Motif Fashion Jewellery Set. Necklace Length 15Pendant Dimension 3.50 x 1.50Earring Dimension 2.00 x 0.80Ethnic Green  White Coloured Stone  Shell Pearl  Gold Plated Hanging Earrings. Dimension 8.50 x 5.30 cmsTrendy Real Big Button Pearl  Gold Plated Pendant  Earring Set with chain. Pearl Dia 89 mm Pendant Dimension 4.20 x 3.00 cms Earring Dimension 3.80 x 2.20 cms Gold Plated Chain Length 22 INRed Green  White stone Pendant Earring Set. Pendant Height 3.50 Chain Length 15 Earring Height 1.75Real Pearl  Gold Plated Pendant with Chain. Pendant Height 1.50 Chain Length 22 Metal Details Gold plated metalBeautifully enamelled lion faced Bangle pair. It adds glamour to you hand  is the ideal Bangle to wear for daily wear.  Bangle Size 2.60 anniShell Pearl  Gold Plated Bangles. 4 pcs. Bangle Size 2.60 anni</shortDescription>
#     <Description>A dazzling red  green kundan Necklace Earring Set . Necklace Length 5.50  extendable Cheddia Earring Height 1.50Peacock Necklace Earring Set. Necklace Length 16 Pendant Height 2.50 with Hook Earring Height 2.00Flower Shaped Golden Jhumki Earrings. Earring Wt 22.00 gms Dimension 5.00 x 2.50 cmsRed  White Kundan Polki Goddess Motif Fashion Jewellery Set. Necklace Length 15Pendant Dimension 3.50 x 1.50Earring Dimension 2.00 x 0.80Ethnic Green  White Coloured Stone  Shell Pearl  Gold Plated Hanging Earrings. Dimension 8.50 x 5.30 cmsTrendy Real Big Button Pearl  Gold Plated Pendant  Earring Set with chain. Pearl Dia 89 mm Pendant Dimension 4.20 x 3.00 cms Earring Dimension 3.80 x 2.20 cms Gold Plated Chain Length 22 INRed Green  White stone Pendant Earring Set. Pendant Height 3.50 Chain Length 15 Earring Height 1.75Real Pearl  Gold Plated Pendant with Chain. Pendant Height 1.50 Chain Length 22 Metal Details Gold plated metalBeautifully enamelled lion faced Bangle pair. It adds glamour to you hand  is the ideal Bangle to wear for daily wear.  Bangle Size 2.60 anniShell Pearl  Gold Plated Bangles. 4 pcs. Bangle Size 2.60 anni</Description>
#     <color>0</color>
#     <qty>1</qty>
#     <pageurl>http://www.suratdiamond.com/H1511.aspx</pageurl>
#     <brand>Surat Diamond</brand>
#   </ProductResult>


doc1 = Nokogiri::XML(File.open("suratdiamondFull")) do |config|
  config.strict.nonet
end

new_book = Spreadsheet::Workbook.new
new_book.create_worksheet :name => 'SDProduct'

product = doc1.search("ProductResult")


row=["itemId" , "Categoryid" , "Subcategory" , "Name" , "Price" , "image" , "Description" , "PDPPage"]
new_book.worksheet(0).insert_row(0,row)


product.each_with_index do |doc,index|
	itemId=doc.search("itemId").text
	Categoryid=doc.search("Categoryid").text
    Subcategoryname=doc.search("Subcategoryname").text
    ProductName=doc.search("ProductName").text
    Productweight=doc.search("Productweight").text
    ListPrice=doc.search("ListPrice").text
    imageTag=doc.search("imageTag").text
    shortDescription=doc.search("shortDescription").text
    Description=doc.search("Description").text
    pageurl=doc.search("pageurl").text
	row=[itemId , Categoryid , Subcategoryname , ProductName , ListPrice , imageTag , Description+shortDescription ,pageurl]
	new_book.worksheet(0).insert_row(index+1,row)
end


new_book.write('suratTestMy.xls')

