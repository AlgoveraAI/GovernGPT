# Description: List files in scraped_data/clean_html folder
require 'nokogiri'
require 'json'

Dir.foreach('scraped_data/clean_html') do |item|
    next if item == '.' or item == '..'

    # get the title of the file
    title = item.split('.')[0]
    # convert _ to space
    title = title.gsub('_', ' ')
    # make the first letter of each word capital
    title = title.split(' ').map(&:capitalize).join(' ')
    # if more than single space convert to single space
    title = title.gsub(/\s+/, ' ')

    # read the html file
    html = File.read('scraped_data/html/' + item)

    # save copy of html to html_copy variable
    html_copy = html

    # convert it to nokogiri object
    doc = Nokogiri::HTML(html)

    # get all h1, h2, h3, h4, h5, h6 tags
    headings = doc.css('h1, h2, h3, h4, h5, h6')

    # get array of text from headings
    headings_text_array = headings.map { |heading| heading.text.strip }

    # get the text inside each section
    # and store it in a hash
    # key: heading text
    # value: text inside the section
    sections = {}
    headings.each_with_index do |heading, index|
        if index == headings.length - 1
            # if it is the last heading tag
            # get the text inside the section
            # and store it in the hash
            section_text = ''
            next_element = heading.next_element
            while !next_element.nil?
                next_element_text = next_element.text.strip
                section_text += next_element_text
                next_element = next_element.next_element
            end
            sections[heading.text.strip] = section_text
            break
        else
            # get the next heading tag
            next_heading = headings[index + 1]
            next_heading_text = next_heading.text.strip
            section_text = '' # text inside the section
            # get the text inside the section
            next_element = heading.next_element
            # if next_element is nil continue to next heading
            # and set the section_text to empty string
            if next_element.nil?
                sections[heading.text.strip] = section_text
                next
            end
            
            # if section_text matches the next heading text stop the loop
            # else get the next element and append it to section_text
            while next_element.text.strip != next_heading_text
                section_text += next_element.text.strip
                # get next element and check if it is nil
                next_element = next_element.next_element
                break if next_element.nil?
            end

            # store the text inside the section in the hash
            sections[heading.text.strip] = section_text
        end
    end

    puts "Title: #{title}"
    puts "Headings: #{headings_text_array}"
    puts "Sections: #{sections}"
    puts "--------------------------------------------"

    # put title, headings and sections in a hash
    data = {
        title: title,
        headings: headings_text_array,
        sections: sections
    }

    # save the data in a json file
    File.open("scraped_data/json/#{title}.json", 'w') do |file|
        file.write(JSON.pretty_generate(data))
    end
end

