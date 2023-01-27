# Description: Prepare prompt/output pair for training GPT-3 model
require 'json'
require 'jsonl'
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

def prompt3_continue_to_write(instruction, data, summary=nil)
    # randomly select an index from the data
    # and use that section as the prompt
    # and the next section as the completion
    prompts = []
    keys = data['sections'].keys
    for i in 0..keys.length - 1
        section_key = keys[i]
        section_text = data['sections'][keys[i]]
        next_section_key = keys[i+1]
        next_section_text = data['sections'][keys[i+1]]
        # if either section_text or next_section_text is empty continue
        if section_text.nil? or next_section_text.nil?
            next
        end
        if summary.nil?
            prompt_text = instruction + section_key + "\n" + section_text + "\n\n###\n\n"
        else
            prompt_text = instruction + "Summary:\n" + summary + "\n" + section_key + "\n" + section_text + "\n\n###\n\n"
        end
        prompt = {
            "prompt": prompt_text,
            "completion": " " + next_section_key + "\n" + next_section_text + "\n"
        }
        prompts << prompt
    end
    prompts
end

# read the JSON files from scraped_data/json folder
all_prompts = []
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
    if !prompt1.nil?
        all_prompts << prompt1
    end

    # prompt 2: summary to outline
    # if summary is not an empty string
    if !summary.empty?
        prompt2 = prompt2_summary_to_outline("Given a summary below write an outline\n", data, summary)
        all_prompts << prompt2
    else
        prompt2 = nil
    end

    # prompt 3: autoregressive
    # given few previous sections continue to write the next section
    prompt3_list = prompt3_continue_to_write("Given previous sections continue to write the next section\n", data)
    all_prompts += prompt3_list

    # prompt 3 list with a summary
    if !summary.empty?
        prompt3_list_with_summary = prompt3_continue_to_write("Given previous sections and a summary continue to write the next section\n", data, summary)
        all_prompts += prompt3_list_with_summary
    else
        prompt3_list_with_summary = nil
    end

end

# write the prompts to a JSONL file
all_prompts_jsonl = JSONL.generate(all_prompts)
File.write('gpt_data/prompts.jsonl', all_prompts_jsonl)
