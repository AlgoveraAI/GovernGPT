# Description: This script scrapes all the posts from the BANKLESS DAO forum and saves them to a folder
# To install dependencies please follow this excellent guide of web scraping from Ryan Kulp
# https://www.founderhacker.com/view/courses/web-scraping/1397383-setting-up-your-environment/4327981-installing-ruby-watir-and-webdrivers

require 'watir'
require 'nokogiri'
require 'open-uri'
require 'net/http'

# open a sitemap with all the links to BANKLESS DAO posts
sitemap = Nokogiri::XML(URI.open('https://forum.bankless.community/sitemap_1.xml'))
urls = sitemap.css('loc').map {|link| link.text}

browser = Watir::Browser.new :chrome, headless: true

# iterate through all the links
total_governance_posts = 0
urls.each do |url|

    # navigate to the link
    browser.goto url

    # topic of the post
    topic = browser.div(class: 'topic-category ember-view').text
    # lower case topic 
    topic.downcase!

    # if governance is in the topic then get the rest
    puts url
    puts topic

    if topic.include? 'governance'
        # get the title of the post
        # title of the post
        title = browser.title
        f_name = title.downcase.gsub(' ', '_')
        # replace / with _
        f_name.gsub!('/', '_')

        puts 'f_name: ' + f_name

        # get the div of the main post
        post_content = browser.div(class: 'regular contents')

        # in text and html formats
        post_content_text = post_content.text
        post_content_html = post_content.html

        # save post_content_html to a file
        File.open('scraped_data/html/' + f_name + '.html', 'w') { |file| file.write post_content_html } 
        # save post_content_text to a file
        File.open('scraped_data/txt/' + f_name + '.txt', 'w') { |file| file.write post_content_text }
        total_governance_posts += 1
        puts 'saved post'
        puts 'total governance posts: ' + total_governance_posts.to_s + ' out of ' + urls.length.to_s
        puts '-----------------'
    else
        puts 'post is not governance related'
        puts '-----------------'
    end
end