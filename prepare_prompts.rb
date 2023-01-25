# Description: Prepare prompt/output pair for training GPT-3 model
require 'json'
require 'pry'

def extract_summary(data)
    # Function that extracts summary from the data
    # and returns it as a string
    summary = ""
    data['sections'].each do |section|
        if section[0].downcase == 'summary' or section[0].downcase == 'tl;dr' or section[0].downcase == 'tldr' or section[0].downcase.include? 'summary'
            summary += section[1].strip + "\n"
        end
    end

    return summary.strip
end

def prompt1_title_to_outline(instruction, data)
    title = data['title']
    headings = data['headings']
    # if headings are empty, return empty prompt
    if headings.empty?
        return nil
    end

    # join headings with a new line
    headings = headings.join("\n").strip
    
    # per openai documentation
    # https://beta.openai.com/docs/guides/fine-tuning/data-formatting
    prompt = {
        "prompt": instruction + title + "\n\n###\n\n",
        "completion": " " + headings + "\n"
    }
    return prompt
end

def prompt2_summary_to_outline(instruction, data, summary)
    headings = data['headings']
    # if headings are empty, return empty prompt
    if headings.empty?
        return nil
    end

    # join headings with a new line
    headings = headings.join("\n").strip
    
    prompt = {
        "prompt": instruction + summary + "\n\n###\n\n",
        "completion": " " + headings + "\n"
    }
    return prompt
end

def prompt3_continue_to_write(instruction, data)
    prompt = ""
    return prompt
end

# read the JSON files from scraped_data/json folder
Dir.foreach('scraped_data/json') do |item|
    next if item == '.' or item == '..'

    # read the JSON file
    json = File.read('scraped_data/json/' + item)
    
    # convert it to a hash
    data = JSON.parse(json)

    # extract summary
    summary = extract_summary(data)

    # prompt 1: title to outline
    prompt1 = prompt1_title_to_outline("Given a title below write an outline\n", data)

    # prompt 2: summary to outline
    # if summary is not an empty string
    if !summary.empty?
        prompt2 = prompt2_summary_to_outline("Given a summary below write an outline\n", data, summary)
    else
        prompt2 = nil
    end

    # prompt 3: autoregressive
    # given few previous sections continue to write the next section
    prompt3 = prompt3_continue_to_write("Given a few previous sections continue to write the next section\n", data)

end
