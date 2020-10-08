require 'nokogiri'
require 'open-uri'

def crypto_scrapper

  doc = Nokogiri::HTML(URI.open('https://coinmarketcap.com/all/views/all/'))
  currencies = []
  prices = []
  doc.css('td.cmc-table__cell--sort-by__symbol > div').each { |node| currencies <<  node.text }
  doc.css('td.cmc-table__cell--sort-by__price > a.cmc-link').each { |node| prices <<  node.text }
  currencies.zip(prices).map{|k, v| {k => v}}

end

puts crypto_scrapper

# {currency: k, price: v}