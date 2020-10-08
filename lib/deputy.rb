require 'nokogiri'
require 'open-uri'
require 'uri'
require 'pry'

def get_deputes_urls
  doc = Nokogiri::HTML(URI.open('http://www2.assemblee-nationale.fr/deputes/liste/alphabetique'))
  page_url = "http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"
  nodeset = doc.css('#deputes-list > div > ul > li > a')
  # https://stackoverflow.com/questions/4861517/how-can-i-get-the-absolute-url-when-extracting-links-using-nokogiri =
  hrefs = nodeset.map { |element| element['href']}.compact 
  hrefs.map { |href| root_href = URI.join(page_url,href).to_s }      
end

def get_deputes_mail(deputy_url = "http://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA605036")
    doc = Nokogiri::HTML(URI.open(deputy_url))
    mail = doc.css('#haut-contenu-page > article > div.contenu-principal.en-direct-commission.clearfix > div > dl > dd > ul > li:nth-child(2) > a').text
end

def dear_deputy(hrefs = get_deputes_urls)
  emails = hrefs.map { |deputy_url| get_deputes_mail(deputy_url) }.compact.reject { |element| element.empty? }
    deputies = []
    emails.each do |mail|
        deputy = Hash.new
      if mail == "ofaure@assemblee-nationale.fr"        
        deputy[:first_name] = "Olivier"
        deputy[:last_name] = "Faure"
        deputy[:mail] = mail.downcase          
      elsif mail == "bureau-m-orphelin@assemblee-nationale.fr"       
        deputy[:first_name] = "Matthieu"
        deputy[:last_name] = "Orphelin"
        deputy[:mail] = mail.downcase          
      else       
        deputy[:first_name] = mail[/^([^.]+)/].capitalize
        deputy[:last_name] = mail[/\..*@/][1..-2].capitalize rescue nil
        deputy[:mail] = mail.downcase                 
      end  
      deputies << deputy rescue nil
    end
    deputies
  end



puts dear_deputy
