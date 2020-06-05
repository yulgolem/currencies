require 'net/http'
require 'rexml/document'

namespace :currency do
  task retrieve_rates: :environment do
    Currency.delete_all
  
    URL = 'http://www.cbr.ru/scripts/XML_daily.asp'
  
    response = Net::HTTP.get_response(URI.parse(URL))
    doc = REXML::Document.new(response.body)
  
    doc.each_element('//Valute') do |currency_tag|
      name = currency_tag.get_text('Name')
      value = currency_tag.get_text('Value')
  
      Currency.create(name:name, rate:"#{value.to_s.gsub!(/\,/,".").to_f}")
    end
  end
end  
