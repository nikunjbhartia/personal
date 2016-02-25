module SmartCollections
  class Base

    include ApiWriter

    # **********************************
    #  Steps to add a smart collection :
    #   1)Add smart collection name in the SMART_COLLECTIONS array
    #   2)Create a method with name = collection_name.downcase.tr(" ","_") which
    #     should return activerecords of product
    # ************************************
    SMART_COLLECTIONS = ["Most Favorited","Most Viewed","Most Chatted","New Shops"]

    # MIN_SCORE is the minimum non inclusive responsive score of the product owner
    # Used in all smart collections
    MIN_SCORE = 50

    # message_type can be [1,2,3,4,5,6,7,8,9,10,11]
    # message_type = 6 is for product share card
    # Used for Most Chatted smart Collection
    MESSAGE_TYPE = [6]

    # @max_products_limit is usedfor preventing RBUFF_FILL READ TIMEOUT ERROR during api calls
    # Should be less than 1700
    # Used in large_products_link_collection and large_products_unlink_collections
    RBUFF_FULL_LIMIT = 1500

    # default @from_date = 15/7/2015 ~ Shopo launch
    # scale : "Minutes" , "Hours" , "Weeks" , "Months" , "Years"
    # Eg.  @from_date = Time.now - 1.week
    #      @from_date = Time.now - 1.Month
    # "1".to_i.send("week") is same as 1.week

    # def initialize(number = nil , scale = nil , max = 150 ,  sample = nil)
    #   if !number.nil? and !scale.nil?
    #     @from_date = Time.now - number.to_i.send(scale)
    #   else
    #     @from_date = Time.new(2015,7,15)
    #   end
    #   @max_products_limit = max
    #   @sample = sample
    # end


    # def unlink_link_products_all_smart_collections
    #   begin
    #     products_unlink_all_smart_collections
    #     large_products_link_all_smart_collections
    #   rescue Exception => e
    #     open("#{Rails.root}/../../shared/log/smart_collection_error_log",'a'){ |f|
    #       f << "\n\n\n ========================= #{Time.now} =========================\n\n"
    #       f << "#{$!} \n"
    #       f << e.backtrace[0]
    #       p e.backtrace
    #     }
    #   end
    # end


    def create_all_smart_collections
      SMART_COLLECTIONS.each do |collection_name|
        create_collection(collection_name)
      end
    end


    def mark_all_smart_collections_inactive
      SMART_COLLECTIONS.each do |collection_name|
        mark_collection_inactive(collection_name)
      end
    end


    def products_unlink_all_smart_collections
      SMART_COLLECTIONS.each do |collection_name|
        products_unlink_collection(collection_name)
      end
    end


    # def products_link_all_smart_collections
    #   SMART_COLLECTIONS.each do |collection_name|
    #     products_link_collection(collection_name)
    #   end
    # end

    # This is to prevent rbuff fill read timeout error due to huge json size
    # def large_products_link_all_smart_collections
    #   SMART_COLLECTIONS.each do |collection_name|
    #     large_products_link_collection(collection_name)
    #   end
    # end


    # def most_favorited
    #   result = Product.joins(:score,:favorites).
    #     select("products.*, COUNT(favorites.id) AS favs_count").
    #     where('favorites.created_at > ? and score > ?',@from_date,MIN_SCORE).
    #     group('products.id').
    #     order("favs_count DESC").
    #     limit(@max_products_limit)

    #   # result = Product.joins(:score,:favorites).
    #   #   select("products.*, COUNT(favorites.id) AS favs_count").
    #   #   where('favorites.created_at > ? and score > ?',@from_date,MIN_SCORE).
    #   #   group('products.id').
    #   #   order("favs_count DESC")
    # end


    # def most_viewed
    #   result = Product.joins(:score).
    #     where("score > ?",MIN_SCORE).
    #     order("view_count Desc").
    #     limit(@max_products_limit)
    # end


    # def most_chatted
    #   #            MYSQL QUERY
    #   # result = Product.find_by_sql("select p.*, count(*) chat_init_count
    #   #                              from shopo_chats.chats c
    #   #                               join treasureProduct.products p on c.product_id = p.id
    #   #                               join sellerdata.responsive_scores s on s.user_id = p.user_id
    #   #                               where message_type = 6 and  s.score > '#{MIN_SCORE}' and c.message_date > '#{@from_date}'
    #   #                               group by product_id, p.name
    #   #                               order by chat_init_count desc")

    #   # ActiveRecord Query (with Limit)
    #   result = Product.joins(:chats,:score).
    #     select("products.*, COUNT(*) AS chat_init_count").
    #     where("message_type in (?) and message_date > ? and score > ?",MESSAGE_TYPE,@from_date,MIN_SCORE).
    #     group("products.id").
    #     order("chat_init_count DESC").
    #     limit(@max_products_limit)

    # end

    # def new_shops
    #   result = []
    #   Product.joins(:user).where("users.created_at > ?",@from_date).select("distinct user_id").each do |p|
    #     result << Product.where("user_id = ?",p.user_id).sample(@sample)
    #   end
    # max_arr = result.max_by(&:length)
    # result -= [max_arr]
    # max_arr.zip(*result).flatten.compact
    # end

    def create_collection(collection_name)
      puts
      p " ======================= Creating Smart collection : #{collection_name} ======================"
      puts
      hsh = get_hash(collection_name)
      write_api("post","collections",hsh.to_json,"id")
    end


    def mark_collection_inactive(collection_name)
      puts
      p " ======================= Marking Smart collection : #{collection_name} Inactive ======================"
      puts
      hsh = get_hash(collection_name)
      hsh[:status] = "INACTIVE"
      collection_ids = get_collection_id(collection_name)

      collection_ids.each do |id|
        write_api("put","collections/#{id}",hsh.to_json,"id")
      end
    end


    def products_unlink_collection(collection_name)
      puts
      p " ======================= Unlinking Products from #{collection_name} ====================== "
      puts
      collection_ids = get_collection_id(collection_name)
      hsh = {}
      collection_ids.each do |collection_id|
        hsh[:collectionId] = collection_id

        product_ids = get_product_ids_by_cid(collection_id)
        hsh[:productIds] = product_ids

        write_api("delete",'collections/unlink-products-collection',hsh.to_json,"response","products")
      end
    end

    # Not used and not required as of now
    def large_products_unlink_collection(collection_name)
      collection_ids = get_collection_id(collection_name)
      hsh = {}
      collection_ids.each do |collection_id|
        hsh[:collectionId] = collection_id

        large_product_ids = (get_product_ids_by_cid(collection_id)).each_slice(RBUFF_FULL_LIMIT).to_a

        large_product_ids.each_with_index do |product_ids,index|
          puts
          p " ======================= Unlinking Set #{index+1}, #{product_ids.size} Products from #{collection_name} ======================"
          puts
          hsh[:productIds] = product_ids
          write_api("delete",'collections/unlink-products-collection',hsh.to_json,"response","products")
        end
      end
    end


    # def products_link_collection(collection_name)
    #   puts
    #   p " ======================= Linking Products To #{collection_name} ======================"
    #   puts
    #   collection_ids = get_collection_id(collection_name)
    #   method_name = collection_name.downcase.tr(" ","_")
    #   product_ids  = send(method_name).map &:id
    #   hsh = {}
    #   hsh[:productIds] = product_ids
    #   hsh[:collectionIds] = collection_ids
    #   hsh[:collectionAutoManagement] = false
    #   write_api("put","products/bulk-update",hsh.to_json,"id")
    # end

    # # This is to prevent rbuf fill read timeout error due to huge json size
    # def large_products_link_collection(collection_name)
    #   collection_ids = get_collection_id(collection_name)
    #   method_name = collection_name.downcase.tr(" ","_")

    #   large_product_ids  = (send(method_name).map &:id).each_slice(RBUFF_FULL_LIMIT).to_a

    #   hsh = {}
    #   hsh[:collectionIds] = collection_ids
    #   hsh[:collectionAutoManagement] = false

    #   large_product_ids.each_with_index do |product_ids,index|
    #     puts
    #     p " ======================= Linking Set #{index+1}, #{product_ids.size} Products To #{collection_name} ======================"
    #     puts

    #     hsh[:productIds] = product_ids
    #     write_api("put","products/bulk-update",hsh.to_json,"id")
    #   end

    # end

    def get_hash(collection_name)
      hsh = {}
      hsh[:name] = collection_name
      hsh[:oldName] = ""
      hsh[:status] = "ACTIVE"
      hsh[:orderNo] = 0
      hsh
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

  end
end
