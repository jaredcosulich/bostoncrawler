require 'open-uri'

class DashboardController < ApplicationController
  
  STARTUP_GUIDE_URL = 'http://bostonstartupsguide.com/'
  
  def index
    
  end
  
  def jobs_pages
    url = STARTUP_GUIDE_URL
    if params[:page].present?
      url += "page/#{params[:page]}/"
    end
    
    startups_page = Nokogiri::HTML(open(url))
    startup_rows = startups_page.css('.post-single')
    @startup_crawlers = startup_rows.collect { |r| StartupCrawler.new(r) }
  end
end
