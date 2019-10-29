#====
#
# Clien News Board Crawling
#
#====

load 'clien.rb'


clien = Clien.new

html_doc = clien.request_news()
clien.parse(html_doc)

# able to access news_list by calling clien.news

