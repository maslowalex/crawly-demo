defmodule AutoriaCars do
  def start_crawl() do 
    Crawly.Engine.start_spider(AutoriaCars.Spider)
  end
end
