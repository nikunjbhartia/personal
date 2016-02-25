require 'spreadsheet'
book = Spreadsheet.open 'category_lines_v3.xls' ; nil
ss =  book.worksheet 'Base'
size = ss.to_a.size
head = ["three_level_l0", "three_level_l1", "three_level_l2", "revised_two_level_l0", "revised_two_level_l1", "current_l0", "current_l1"]
arr = []
(1..size-1).each do |i|
  begin
    print ".#{i}"
    row = ss.row(i)
    row = Hash[[head,ss.row(i)].transpose]
    arr << row["current_l0"]
    arr << row["current_l1"]
  end
end
unique = arr.uniq
all_in_categories = Category.select(:name).where("name in (?)",unique)
all_notin_categories = Category.select(:name).where("name not in (?)",unique)
active_categories = all_notin_categories.where(status: "ACTIVE")
inactive_categories = all_notin_categories.where(status: "INACTIVE")


 # unique = arr.uniq
    # all_in_categories = Category.select(:name).where("name in (?)",unique)
    # all_notin_categories = Category.select(:name).where("name not in (?)",unique)
    # active_categories = all_notin_categories.where(status: "ACTIVE")
    # inactive_categories = all_notin_categories.where(status: "INACTIVE")


  # ["TVs, Cameras & Appliances", "Baby food", "Baby skin care", "Breast Pump",
  # "Pram and Strollers", "Connectors", "Fans & Coolers", "Frozen food", "Dining linen & décor",
  #  "Kids décor", "Casual wear", "Scarfs, Stoles", "TV, Home theatre", "Suits, Sarees",
  #  "Tops, Tees, Blouses", "Ethnic footwear", "Shoes", "Straps & Sandals",
  #  "Art, Craft & Collectibles"]

   
  # establish_connection "user_#{Rails.env}".to_sym

 # ["TVs, Cameras & Appliances", "Baby food", "Baby skin care", "Breast Pump",
 # "Pram and Strollers", "Connectors", "Fans & Coolers", "Frozen food", "Dining linen & décor",
 #  "Kids décor", "Casual wear", "Scarfs, Stoles", "TV, Home theatre", "Suits, Sarees", 
 #  "Tops, Tees, Blouses", "Ethnic footwear", "Shoes", "Straps & Sandals",
 #  "Art, Craft & Collectibles"] 


 # establish_connection "user_#{Rails.env}".to_sym