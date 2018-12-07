require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  def self.scrape_index_page(index_url)
    doc = open(index_url).read
    html = Nokogiri::HTML(doc)

    html.css('div.student-card').map do |student|
      {
        name: student.css('a div.card-text-container h4').text,
        location: student.css('a div.card-text-container p').text,
        profile_url: student.css('a').attribute('href').value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = open(profile_url).read
    html = Nokogiri::HTML(doc)
    profile = {}

    profile[:profile_quote] = html.css("div.vitals-text-container div.profile-quote").text
    profile[:bio] = html.css("div.bio-content.content-holder div.description-holder p").text

    html.css("div.social-icon-container a").each do |social|
      if social.attribute("href").text.include?("twitter")
        profile[:twitter] = social.attribute("href").text
      elsif social.attribute("href").text.include?("linkedin")
        profile[:linkedin] = social.attribute("href").text
      elsif social.attribute("href").text.include?("github")
        profile[:github] = social.attribute("href").text
      else
        profile[:blog] = social.attribute("href").text
      end
    end
    profile
  end
end  
  
