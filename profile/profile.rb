$:.push File.expand_path("../../lib", __FILE__)
require "nori"
require "ruby-prof"

xml = File.read File.expand_path("../../benchmark/soap_response.xml", __FILE__)

Nori.new.parse('<root/>') #require nokogiri.rb in advance

RubyProf.start
  Nori.new.parse(xml)
result = RubyProf.stop

flat_printer = RubyProf::FlatPrinter.new(result)
html_printer = RubyProf::GraphHtmlPrinter.new(result)

File.open("profile/flat.prof", 'w') { |f| flat_printer.print(f) }
File.open("profile/html.prof", 'w') { |f| html_printer.print(f) }
