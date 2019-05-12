require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    flatiron = Nokogiri::HTML(open(index_url))
    students_ar = []
    flatiron.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        student_url = "#{student.attr('href')}"
        students_ar << {name: student_name, location: student_location, profile_url: student_url}
      end
    end
    students_ar
  end

  def self.scrape_profile_page(profile_url)
    flatiron = Nokogiri::HTML(open(profile_url))
    student = {}
    student_links = flatiron.css(".social-icon-container").children.css("a").map do |link|
      link.attribute("href").value
    end
    student_links.each do |link|
      if link.include?("linkedin")
        student[:linkedin]=link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else 
        student[:blog] = link
      end
    end
    student[:profile_quote] = flatiron.css(".profile-quote").text if flatiron.css(".profile-quote")
    student[:bio] = flatiron.css("div.bio-content.content-holder div.description-holder p").text if flatiron.css("div.bio-content.content-holder div.description-holder p")
    student
  end

end

