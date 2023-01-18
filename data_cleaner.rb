# Description: List files in scraped_data/html folder and clean them

Dir.foreach('scraped_data/html') do |item|
    next if item == '.' or item == '..'
    
    # read the html file
    html = File.read('scraped_data/html/' + item)

    # save copy of html to html_copy variable
    html_copy = html

    # remove all div tags
    html.gsub!(/<div.*?>/, '')
    # remove all closing div tags
    html.gsub!(/<\/div>/, '')

    # remove all class= inside the tags
    html.gsub!(/class=".*?"/, '')
    # remove all id= inside the tags
    html.gsub!(/id=".*?"/, '')

    # remove all style= inside the tags
    html.gsub!(/style=".*?"/, '')

    # remove all data- inside the tags
    html.gsub!(/data-.*?=".*?"/, '')

    # remove all aria- inside the tags
    html.gsub!(/aria-.*?=".*?"/, '')

    # remove all role= inside the tags
    html.gsub!(/role=".*?"/, '')

    # remove all tabindex= inside the tags
    html.gsub!(/tabindex=".*?"/, '')

    # remove all rel= inside the tags
    html.gsub!(/rel=".*?"/, '')

    # remove all target= inside the tags
    html.gsub!(/target=".*?"/, '')

    # remove all href= inside the tags
    html.gsub!(/href=".*?"/, '')

    # remove all src= inside the tags
    html.gsub!(/src=".*?"/, '')

    # remove all alt= inside the tags
    html.gsub!(/alt=".*?"/, '')

    # remove all title= inside the tags
    html.gsub!(/title=".*?"/, '')

    # remove all aria-label= inside the tags
    html.gsub!(/aria-label=".*?"/, '')

    # remove all aria-labelledby= inside the tags
    html.gsub!(/aria-labelledby=".*?"/, '')

    # remove all aria-describedby= inside the tags
    html.gsub!(/aria-describedby=".*?"/, '')

    # remove all aria-hidden= inside the tags
    html.gsub!(/aria-hidden=".*?"/, '')

    # remove all aria-expanded= inside the tags
    html.gsub!(/aria-expanded=".*?"/, '')

    # remove all aria-current= inside the tags
    html.gsub!(/aria-current=".*?"/, '')

    # remove all aria-controls= inside the tags
    html.gsub!(/aria-controls=".*?"/, '')

    # remove all aria-selected= inside the tags
    html.gsub!(/aria-selected=".*?"/, '')

    # remove all aria-haspopup= inside the tags
    html.gsub!(/aria-haspopup=".*?"/, '')

    # replace spaces with more than 1 space with 1 space
    html.gsub!(/\s{2,}/, ' ')

    # remove all svg and img tags
    html.gsub!(/<svg.*?>.*?<\/svg>/, '')
    html.gsub!(/<img.*?>/, '')

    # remove all button tags
    html.gsub!(/<button.*?>.*?<\/button>/, '')
    
    # save html to scraped_data/clean_html folder
    File.open('scraped_data/clean_html/' + item, 'w') { |file| file.write html }

end
