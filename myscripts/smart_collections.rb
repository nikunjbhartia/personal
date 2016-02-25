class SmartCollections
  include ApiWriter

  # DB problem :
  # Time saved in database is Time.now.utc - 5.hrs -30.minutes but it should be
  #  Time.now.utc + 5.hrs + 30.minutes
  # check Favorite.last in staing app

  SMART_COLLECTIONS = ["Most Favorited","Most Viewed","Most Chatted"]
  SCORE = 50
  # Shopo launch 15/7/2015

  # Scale : Minutes , Hours , Week , Month , Year
  #  eg. Time.now - 1.week
  # Time.now - 1.Month
  # "1".to_i.send("week") is same as 1.week
  def initialize(number = nil , scale = nil)
    if !number.nil? and !scale.nil?
      @from_date = Time.now - number.to_i.send(scale)
    else
      @from_date = Time.new(2015,7,15)
    end
  end


  def start
    begin
      products_unlink_all_smart_collections
      products_link_all_smart_collections
    rescue Exception => e
      open("shared/log/smart_collection_log",'a'){ |f|
        f << "\n\n========================= #{Time.now} =========================\n"
        f << "#{$!} \n"
        f << e.backtrace[0]
        p e.backtrace
      }
    end
  end


  def most_favorited
    # result1 = Product.select("products.*, COUNT(favorites.id) AS favs_count").
    #   joins(:favorites).
    #   where('favorites.created_at > ?',@from_date).
    #   group('products.id').order("favs_count DESC").
    #   map{|p| p if !p.score.nil? and p.score.score > SCORE }.
    #   compact

    result = Product.joins(:score,:favorites).select("products.*, COUNT(favorites.id) AS favs_count").
      where('favorites.created_at > ? and score > ?',@from_date,SCORE).
      group('products.id').order("favs_count DESC")
  end

  def most_viewed
    # result = Product.order("view_count Desc").limit(10000)
    # map{|p| p if !p.score.nil? and p.score.score > SCORE }.
    #   compact

    result = Product.joins(:score).where("score > ?",SCORE).order("view_count Desc")

  end

  def most_chatted
    # result = Product.find_by_sql("select * from treasureProduct.products P
    # INNER JOIN (
    # select *,count(DISTINCT signature) as chat_init_count
    #  from (select product_id, case when from_user < to_user
    #       then concat(from_user, '#', to_user)
    #       else concat(to_user, '#', from_user)
    #       end as signature
    #       from shopo_chats.chats) t1
    #  group by product_id ) T
    #  ON P.id = T.product_id;")

 q=Chat.where(product_id: 9600 )
 t = q.map{|chats| case when chats.from_user < chats.to_user 
                         then chats.from_user.to_s + "#" +  chats.to_user.to_s 
                        else chats.to_user.to_s + "#" + chats.from_user.to_s 
                   end }
 ut=t.uniq
 cc=ut.size


    result = Product.find_by_sql("select * from treasureProduct.products P
                     INNER JOIN (select *,count(DISTINCT signature) as chat_init_count 
                                 from (select product_id, case when from_user < to_user 
                                                           then concat(from_user, '#', to_user) 
                                                           else concat(to_user, '#', from_user) 
                                                          end as signature 
                                        from shopo_chats.chats
                                        where created_at > '#{@from_date}') t1                                
                                group by product_id
                                order by chat_init_count Desc) T 
                     ON P.id = T.product_id;").
      map{|p| p if !p.score.nil? and p.score.score > SCORE }.
      compact

    result1 = Product.joins(:score,:chat).
      select("products.* , 
      	      COUNT(DISTINCT case when chats.from_user < chats.to_user 
                    then concat(chats.from_user, '#', chats.to_user) 
                    else concat(chats.to_user, '#', chats.from_user) 
               end) as chat_init_count").
      where("chats.created_at > ? and score > ? ",@from_date,SCORE).
      group('products.id').
      order("chat_init_count DESC")


  end

  def get_hash(collection_name)
    hsh = {}
    hsh[:name] = collection_name
    hsh[:oldName] = ""
    hsh[:status] = "ACTIVE"
    hsh[:orderNo] = 0
    hsh
  end

  def create_collection(collection_name)
    hsh = get_hash(collection_name)
    write_api("post","collections",hsh.to_json,"id")
  end

  def create_all_smart_collections
    SMART_COLLECTIONS.each do |collection_name|
      create_collection(collection_name)
    end
  end

  def mark_collection_inactive(collection_name)
    hsh = get_hash(collection_name)
    hsh[:status] = "INACTIVE"
    collection_ids = get_collection_id(collection_name)

    collection_ids.each do |id|
      write_api("put","collections/#{id}",hsh.to_json,"id")
    end
  end


  def mark_all_smart_collections_inactive
    SMART_COLLECTIONS.each do |collection_name|
      mark_collection_inactive(collection_name)
    end
  end


  def get_collection_id(collection_name)
    ids = Collection.select(:id).where("name like ?",collection_name).map &:id
    ids.uniq
  end


  def get_product_ids_by_cname(collection_name)
    c_ids = get_collection_id(collection_name)
    product_ids = (ProductsCollection.where(collection_id: c_ids).all.map &:product_id).uniq
    product_ids
  end


  def get_product_ids_by_cid(c_id)
    product_ids = (ProductsCollection.where(collection_id: c_id).all.map &:product_id).uniq
    product_ids
  end


  def products_unlink(collection_name)
    collection_ids = get_collection_id(collection_name)
    hsh = {}
    collection_ids.each do |collection_id|
      hsh[:collectionId] = collection_id

      product_ids = get_product_ids_by_cid(collection_id)
      hsh[:productIds] = product_ids

      write_api("delete",'collections/unlink-products-collection',hsh.to_json,"response","products")
    end
  end


  def products_unlink_all_smart_collections
    SMART_COLLECTIONS.each do |collection_name|
      products_unlink(collection_name)
    end
  end

  def products_link(collection_name)
    collection_ids = get_collection_id(collection_name)
    method_name = collection_name.downcase.tr(" ","_")
    product_ids  = send(method_name).map &:id
    hsh = {}
    hsh[:productIds] = product_ids
    hsh[:collectionIds] = collection_ids
    hsh[:collectionAutoManagement] = false
    write_api("put","products/bulk-update",hsh.to_json,"id")
  end

  def products_link_all_smart_collections
    SMART_COLLECTIONS.each do |collection_name|
      products_link(collection_name)
    end
  end

end
