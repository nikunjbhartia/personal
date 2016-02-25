require "forwardable"
module SmartCollections
  class MostViewed < Base
    extend Forwardable

    def initialize(number = nil , scale = nil , max = 150 ,  sample = nil)
      if !number.nil? and !scale.nil?
        @from_date = Time.now - number.to_i.send(scale)
      else
        @from_date = Time.new(2015,7,15)
      end
      @max_products_limit = max
      @sample = sample
    end


    def unlink_link_products
      begin
        products_unlink_collection("Most Viewed")
        large_products_link_collection("Most Viewed")
      rescue Exception => e
        # open("#{Rails.root}/../../shared/log/most_viewed_smart_collection_error_log",'a'){ |f|
        open("shared/log/most_viewed_smart_collection_error_log",'a'){ |f|
          f << "\n\n\n ========================= #{Time.now} =========================\n\n"
          f << "#{$!} \n"
          f << e.backtrace[0]
          p e.backtrace
        }
      end
    end


    # This is to prevent rbuf fill read timeout error due to huge json size
    def large_products_link_collection(collection_name)
      collection_ids = get_collection_id(collection_name)
      method_name = collection_name.downcase.tr(" ","_")

      large_product_ids  = (send(method_name).map &:id).each_slice(RBUFF_FULL_LIMIT).to_a

      hsh = {}
      hsh[:collectionIds] = collection_ids
      hsh[:collectionAutoManagement] = false

      large_product_ids.each_with_index do |product_ids,index|
        puts
        p " ======================= Linking Set #{index+1}, #{product_ids.size} Products To #{collection_name} ======================"
        puts

        hsh[:productIds] = product_ids
        write_api("put","products/bulk-update",hsh.to_json,"id")
      end

    end


    def most_viewed
      result = Product.joins(:score).
        where("score > ?",MIN_SCORE).
        order("view_count Desc").
        limit(@max_products_limit)
    end

  end
end
