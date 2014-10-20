require 'open-uri'
require 'net/http'

class StartupCrawler
  JOBS_PATHS = ['jobs', 'careers', 'join']
  
  def initialize(html)
    @html = html
  end
  
  def name
    @html.css('a.startup-link').first.attributes['title'].value
  end

  def url
    @html.css('a.startup-link').first.attributes['href'].value
  end
  
  def jobs_page
    return @jobs_page_path if @jobs_page_path.present?
    existing_link = @html.css('span.jobs-link a').first
    if existing_link.present?
      @jobs_page_path = existing_link.attributes['href'].to_s 
      return @jobs_page_path
    end
      
    JOBS_PATHS.each do |path|
      location = url + (url.ends_with?('/') ? '' : '/') + path
      # full_path = full_path.gsub('http', 'https')
      @jobs_page_path = get_page(location)  
      return @jobs_page_path
    end
    return '' 
  end
  
  def get_page(location)
    begin
      uri = URI.parse(location)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 1
      if location.index('https').present?
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      if response.code == '200'
        return location
      elsif response.code == '302' or response.code == '301'
        puts response['location'] + ' = ' + location
        puts response.inspect
        return get_page(response['location'])
      end
    rescue Exception => e
      puts "FAILED #{location} - #{e.inspect}"
    end
    return nil
  end
end