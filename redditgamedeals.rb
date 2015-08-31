require 'open-uri'
require 'nokogiri'

count=0

puts " "
puts "=================="
puts "Reddit GameDeals"
puts "=================="
puts " "

docnew = Nokogiri::HTML(open("https://www.reddit.com/r/gamedeals/new/.compact"))
docnew.remove_namespaces!
newdeals = docnew.xpath("//div[@class='content']/div[@id='siteTable']/div")

puts "5 recent deals"
puts " "

newdeals[0..4].each do |nd|
    count+=1
    puts nd.at_css('p/a').text
    slink = nd.at_css("p[@class='title']/a/@href") # link from store
    rlink = nd.at_css('@href') # reddit link
    puts "Store link: #{slink.text}"
    puts "Reddit thread link: #{rlink.text}"
    puts nd.at_css("/div[@class='commentcount']/a").text + " comments" + " | " +
         nd.at_css("/div[@class='entry unvoted']/div/span[1]/time")
    time = nd.at_css("/div[@class='entry unvoted']/div/span[1]/time")
    timeutc = nd.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
    puts "Time posted: #{time.text} | " + "#{timeutc.text}"
    puts " "
end

doc = Nokogiri::HTML(open("https://i.reddit.com/r/gamedeals"))
doc.remove_namespaces!
deals = doc.xpath("//div[@class='content']/div[@id='siteTable']/div")

puts "Popular Deals"
puts "============="
puts " "

deals[1..-1].each do |dl|
    count+=1
    puts dl.at_css('p/a').text
    slink = dl.at_css("p[@class='title']/a/@href")
    rlink = dl.at_css('@href')
    puts "Store link: #{slink.text}"
    puts "Reddit thread link: #{rlink.text}"
    puts dl.at_css("div[@class='commentcount']/a").text + " comments" + " | " +
         dl.at_css("/div[@class='entry unvoted']/div/span[1]/span")
    time = dl.at_css("/div[@class='entry unvoted']/div/span[1]/time")
    timeutc = dl.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
    puts "Time posted: #{time.text} | " + "#{timeutc.text}"
    puts " "
end

puts "#{count} sales found"
puts " "