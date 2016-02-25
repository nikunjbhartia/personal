
module Crawlers
  class Geekgoodies
    include ApiWriter
    attr_accessor :patterns

    def initialize(cart,user_id,city)
      @cart=cart
      @agent = Mechanize.new
      @patterns = YAML.load_file("#{Rails.root}/config/patterns/#{cart}_pattern.yml")
      @agent.open_timeout=15
      @agent.read_timeout=15
      @category_id = [531,531,606,606,569,569,569,569,646,568,550,547,547,610]
      @user_id = user_id
      @city = city
      @category_links_all = [
        "http://geekgoodies.in/index.php?route=product/category&path=99_100",
        "http://geekgoodies.in/index.php?route=product/category&path=99_102",
        "http://geekgoodies.in/index.php?route=product/category&path=95_96",
        "http://geekgoodies.in/index.php?route=product/category&path=95_97",
        "http://geekgoodies.in/index.php?route=product/category&path=90_91",
        "http://geekgoodies.in/index.php?route=product/category&path=90_92",
        "http://geekgoodies.in/index.php?route=product/category&path=90_93",
        "http://geekgoodies.in/index.php?route=product/category&path=90_94",
        "http://geekgoodies.in/index.php?route=product/category&path=88",
        "http://geekgoodies.in/index.php?route=product/category&path=98",
        "http://geekgoodies.in/index.php?route=product/category&path=84_85",
        "http://geekgoodies.in/index.php?route=product/category&path=84_86",
        "http://geekgoodies.in/index.php?route=product/category&path=84_87",
        "http://geekgoodies.in/index.php?route=product/category&path=103"
      ]
    end

    def process_category_links
      @category_links_all.each_with_index do |i,index|
        begin
          @category=i
          @index=index
          process_category(i+"&limit=100")
          rescue Exception => e
          open("#{Rails.root}/../../shared/log/#{@cart}_crawl_log",'a'){ |f|
            f << "\n\n==========================\n"
            f << "#{@url+@current_page.to_s} \n"
            f << "Product = #{@listing_link}\n"
            f << "Error during processing: #{$!} \n"
            f << "=========================="
          }
        end
      end
    end

    def process_category(url)
      @url = url
      crawl
    end

    def crawl
      @page = @agent.get(@url)
      process_page
    end
 
  def process_page
    @item_links = @page.search(@patterns['reach_item'])
    process_item_links
  end

  def process_item_links
    @item_links.each do |link|
      @listing_link = link.attr("href")
      process_listing
    end
  end

  def process_listing
    begin
      p "=============== Going to Category - #{@category} ==============="
      p @listing_link
      p "=============================== Going to Process the Listing - In Page #{@current_page} ========================="
      @listing_page = @agent.get(@listing_link)
      hsh = prepare_listing
      write_api('post','products',hsh.to_json,"message")
    rescue Exception => e
      open("#{Rails.root}/../../shared/log/#{@cart}_crawl_log",'a'){ |f|
        f << "\n\n==========================\n"
        f << "#{@url+@current_page.to_s} \n"
        f << "Product = #{@listing_link}\n"
        f << "Error during processing: #{$!} \n"
        f << "=========================="
      }
    end
  end

  def extract(key)
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
    extract("price").first.text.scan(/\d+,*.*\d*/).first.gsub(",","")
  end

  def images
    images = extract("images").map {|i| i.attr("data-largeimg")  }
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
    hsh[:categoryId] = @category_id[@index]
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
