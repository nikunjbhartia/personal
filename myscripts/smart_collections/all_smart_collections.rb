require "forwardable"
module SmartCollections
  class AllSmartCollections < Base
    extend Forwardable

    def initialize(number = nil , scale = nil , max = 150 ,  sample = nil)
      @mf = MostFavorited.new(number,scale,max,sample)
      @mv = MostViewed.new(number,scale,max,sample)
      @mc = MostChatted.new(number,scale,max,sample)
      @ns = NewShops.new(number,scale,max,sample)
    end

    def unlink_link_products_all_smart_collections
      begin
        @mf.unlink_link_products
        @mv.unlink_link_products
        @mc.unlink_link_products
        @ns.unlink_link_products
      rescue Exception => e
        open("#{Rails.root}/../../shared/log/all_smart_collection_error_log",'a'){ |f|
          f << "\n\n\n ========================= #{Time.now} =========================\n\n"
          f << "#{$!} \n"
          f << e.backtrace[0]
          p e.backtrace
        }
      end
    end
  end
end
