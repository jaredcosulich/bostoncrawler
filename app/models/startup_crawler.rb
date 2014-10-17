require 'open-uri'

class StartupCrawler
  
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
    existing_link = @html.css('span.jobs-link a').first
    return existing_link.attributes['href'].to_s if existing_link.present?
    # 
    # website_html = 
  end
  
  
end