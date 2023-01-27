# 🏗 GovernGPT

This project aims to develop GovernGPT which assists governors and professional delegates in DAOs to build and summarise proposals. This proposal is specifically geared to support [DAOStewards](https://bankless.notion.site/DAOstewards-24f0aba00eb743459f554fca9a8c9847) a meta-governance group from BanklessDAO with active delegations in Euler.Finance, SAFE DAO & 1inchDAO. 

You can read more about the project [here](https://forum.algovera.ai/t/proposal-gpt3-for-dao-governance/307). 

# 🤖 Algovera Flow

This workflow will soon be added to the [Algovera platform](https://app.algovera.ai/workflows). Check it out if you're interested in using this workflow (and others) to augment your daily work with LLMs. 

# 👪 Grants 

You can get funded to build your LLM workflow through Algovera Grants. Each month, we give out $10k of grants to projects. For examples of previous proposals, check out our [forum](https://forum.algovera.ai/). For more information on the proposal process, check out our [docs](https://docs.algovera.ai/blog/). We're very grateful to [Ocean Protocol Foundation](https://oceanprotocol.com/) for sponsoring Algovera Grants. 

[Website](https://www.algovera.ai/) | [Twitter](https://twitter.com/AlgoveraAI)  | [Discord](https://discord.gg/e65RuHSDS5)

# 🚜 Files

- `scraper.rb`: Scraper that scrapes over the governance proposals in Bankless DAO
- `data_cleaner.rb`: Data Cleaner that cleans out the unneccessary HTML tags from the scraped governance proposals
- `prepare_dataset.rb`: Convert HTML into the structured JSON format that contains title, headings, and sections. This JSON is used in turn to generate prompt/output pairs for OpenAI GPT model fine-tuning
- `prepare_prompts.rb`: Script that converts the scraped data in JSON format into the prompts/outputs used to fine-tune GPT.

# 📁 Data

- `scraped_data/prompts_prepared.jsonl`: Prompts and outputs prepared for fine-tuning after running `openai tools fine_tunes.prepare_data -f gpt_data/prompts.jsonl` script
- `scraped_data/prompts.jsonl`: Prompts and outputs initially prepared for fine-tuning
- `scraped_data/json`: Cleaned up JSON of governance proposals that contains title, headings, and sections. Used to generate prompts/outputs for fine-tuning
- `scraped_data/clean_html`: Cleaned up HTML of governance proposals
- `scraped_data/html`: Original raw HTML data scraped
- `scraped_data/txt`: Original raw TXT data scraped