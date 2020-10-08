# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'uri'

def get_townhall_email(townhall_url)
  doc = Nokogiri::HTML(URI.open(townhall_url))
  email = doc.css('section:nth-child(2) > div > table > tbody > tr:nth-child(4) > td:nth-child(2)').text
end

def get_townhall_urls
  doc = Nokogiri::HTML(URI.open('http://annuaire-des-mairies.com/val-d-oise.html'))
  page_url = 'http://annuaire-des-mairies.com/val-d-oise.html'
  nodeset = doc.css('td >p > a')
  # https://stackoverflow.com/questions/4861517/how-can-i-get-the-absolute-url-when-extracting-links-using-nokogiri =
  hrefs = nodeset.map { |element| element['href']}.compact
  hrefs.map { |href| root_href = URI.join(page_url, href).to_s }
end

def get_townhall_list
  doc = Nokogiri::HTML(URI.open('http://annuaire-des-mairies.com/val-d-oise.html'))
  townhalls = doc.css('td >p > a').map { |element| element.text.gsub(/\w+/, &:capitalize) }
end

def mairie_christmas(hrefs = get_townhall_urls)
  emails = hrefs.map { |townhall_url| get_townhall_email(townhall_url) }
  townhalls = get_townhall_list
  townhalls.zip(emails).map { |k, v| { k => v }}
end

def perform 
  puts mairie_christmas
end

perform