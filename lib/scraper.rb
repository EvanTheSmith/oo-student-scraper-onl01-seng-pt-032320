require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url)).css("div.student-card")
    doc.each do |dude|
      my_hash = {
        :name => dude.css(".student-name").text,
        :location => dude.css(".student-location").text,
        :profile_url => dude.css("a").attribute("href").text
      }
      students << my_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    socials = []
    doc = Nokogiri::HTML(open(profile_url))
    twitter = nil;linkedin = nil;github = nil;blog = nil
    
    doc.css(".social-icon-container a").each {|social| socials << social.attribute("href").text}
    socials.each do |soc_check|
        if soc_check.include?("twitter")
          twitter = soc_check
        elsif soc_check.include?("linked")
          linkedin = soc_check
        elsif soc_check.include?("github")
          github = soc_check
        else
          blog = soc_check
        end # if twitter/linked/github
    end # socials

    profile_quote = doc.css(".profile-quote").text
    bio = doc.css(".description-holder p").text

    my_hash = {
        :twitter => twitter,
        :linkedin => linkedin,
        :github => github,
        :blog => blog,
        :profile_quote => profile_quote,
        :bio => bio
      }

    my_hash = my_hash.delete_if { |k, v| v.nil? }
  end # def

end

