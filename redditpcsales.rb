require 'open-uri'
require 'nokogiri'

count=0

puts " "
puts "======================="
puts "Reddit Build-a-PC Sales"
puts "======================="
puts " "

docnew = Nokogiri::HTML(open("https://www.reddit.com/r/buildapcsales/new/.compact"))
docnew.remove_namespaces!
newsales = docnew.xpath("//div[@class='content']/div[@id='siteTable']/div")

puts "5 recent deals"
puts " "

newsales[0..4].each do |nw|
    count+=1
    puts nw.at_css('p/a').text
    slink = nw.at_css("p[@class='title']/a/@href")
    link = nw.at_css('@href')
    puts "Store link: #{slink.text}"
    puts "Reddit thread link:  #{link.text}"
    puts nw.at_css("div[@class='commentcount']/a").text + " comments | " + 
         nw.at_css("/div[@class='entry unvoted']/div/span[1]/span")
    time = nw.at_css("/div[@class='entry unvoted']/div/span[1]/time")
    timeutc = nw.at_css("div[@class='entry unvoted']/div/span[1]/time/@title")
    puts "Time posted: #{time.text} | " + "#{timeutc.text}"
    puts " "
end

puts "Popular Deals"
puts "============="
puts " "

dochot = Nokogiri::HTML(open("https://i.reddit.com/r/buildapcsales"))
dochot.remove_namespaces!
hotsales = dochot.xpath("//div[@class='content']/div[@id='siteTable']/div")

hotsales[1..-1].each do |sl|
    count+=1
    puts sl.at_css('p/a').text
    slink = sl.at_css("p[@class='title']/a/@href")
    link = sl.at_css('@href')
    puts "Store link: #{slink.text}"
    puts "Reddit thread link:  #{link.text}"
    puts sl.at_css("div[@class='commentcount']/a").text + " comments | " + 
         sl.at_css("/div[@class='entry unvoted']/div/span[1]/span")
    time = sl.at_css("/div[@class='entry unvoted']/div/span[1]/time")
    timeutc = sl.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
    puts "Time posted: #{time.text} | " + "#{timeutc.text}"
    puts " "
end

puts "#{count} sales found"
puts " "
