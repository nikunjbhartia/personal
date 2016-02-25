
  module Crawlers
  class Base
    include ApiWriter
    attr_accessor :patterns

    def initialize(cart,url,category_id,user_id,city,total_pages,start_page = 1)
      @cart=cart
      @url = url
      @category_id = category_id
      @user_id = user_id
      @city = city
      @agent = Mechanize.new
      @total_pages = total_pages
      @start_page = start_page
      @patterns = YAML.load_file("#{Rails.root}/config/patterns/#{cart}_pattern.yml")
      @agent.open_timeout=15
      @agent.read_timeout=15
    end

    
    def crawl
      (@start_page..@total_pages).each do |page|
        @current_page = page
        @page = @agent.get(@url + page.to_s)
        process_page        
      end
    end

    def process_page
      @item_links = @page.search(@patterns['reach_item'])
      process_item_links
    end

    def process_item_links
      @item_links.each do |link|
        begin
        @listing_link = link.attr("href")
        process_listing
        rescue Exception => e
          open("shared/log/#{@cart}_crawl_log",'a'){ |f|
            f << "\n\n==========================\n"
            f << "#{@url+page.to_s} \n"
            f << "Product = #{@listing_link}\n"
            f << "Error during processing: #{$!} \n"
            f << "Backtrace:\n\t#{e.backtrace.join("\n\t")}\n"
            f << "=========================="
          }
        end
      end
    end

    def process_listing
      begin
      p "=============================== Going to Process the Listing - In Page #{@current_page} ==========================="
      p @listing_link
      p "==================================================================================================================="
      @listing_page = @agent.get(@listing_link)

      hsh = prepare_listing
      write_api('post','products',hsh.to_json,"message")

      rescue Exception => e
          open("shared/log/#{@cart}_crawl_log",'a'){ |f|
            f<<"\n\n==========================\n"
            f<< "#{@url+page.to_s} \n"
            f<< "Product = #{@listing_link}\n"
            f << "Error during processing: #{$!} \n"
            f << "Backtrace:\n\t#{e.backtrace.join("\n\t")}\n"
            f<<"=========================="
          }
      end

    end

    def extract(key)
      begin
      str = @patterns[key]
      pattern = str.is_a?(Array) ? str.first : str

      if pattern.blank?
        result = nil
      else
        result = @listing_page.search(pattern)
      end

      if result.blank? && @patterns[key].is_a?(Array)
        result = @listing_page.search(str[1])
      end
      rescue Exception => e
          open("shared/log/#{@cart}_crawl_log",'a'){ |f|
            f << "\n\n==========================\n"
            f << "#{@url+page.to_s} \n"
            f << "Product = #{@listing_link}\n"
            f << "Error during processing: #{$!} \n"
            f << "Backtrace:\n\t#{e.backtrace.join("\n\t")}\n"
            f << "=========================="
          }
      end 
      result
    end

    def name
      extract("name").first.text
    end

    def desc
       extract("desc").first.text.squish rescue nil
    end

    def mrp
      extract("mrp").first.text.squish.tr(",","").scan(/[0-9]+\.[0-9]+/).join rescue nil
    end

    def price
      extract("price").first.text.squish.tr(",","").scan(/[0-9]+\.[0-9]+/).join
    end

    def images
      images = extract("images").map {|i| i.attr("src") }
      final_images = []
      products_import = ProductsImport.new
      images.each do |img|
        final_images << products_import.upload_to_cloudinary(img)
      end
      final_images
    end

    def prepare_listing
      hsh = {}
      hsh[:name] = name
      hsh[:description] = desc
      hsh[:price],hsh[:applicablePrice] = mrp, price
      hsh[:productCondition] = "new"
      hsh[:categoryId] = @category_id
      hsh[:userId] = @user_id
      hsh[:city] = @city

      hsh[:locality] = ""
      hsh[:latitude] = 0
      hsh[:longitude] = 0
      hsh[:googlePlaceId] = ""

      hsh[:images] = images
      hsh[:source] = "ADMIN"
      hsh
    end
  end
end
