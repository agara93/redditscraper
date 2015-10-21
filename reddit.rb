require 'open-uri'
require 'nokogiri'

loop do

count=0

puts ""
puts "================"
puts "Ruby Reddit"
puts "================"
puts ""

print "Subreddit: "
subr = gets.chomp

subreddit = "https://www.reddit.com/r/#{subr}/.compact"
subrmetrics = "http://redditmetrics.com/r/#{subr}"
docsubrm = Nokogiri::HTML(open(subrmetrics))
subdesc = ""
if subr != 'all'
    subdesc = docsubrm.at_css("/html/body/div[@class='container']/blockquote").text
end

puts ""
puts "=============================================="
puts "Welcome to r/#{subr}"
puts "[#{subreddit}]"
puts ""
puts "#{subdesc}"
puts "=============================================="
puts ""

print "Sort by [new/hot/top/custom]: "
sort = gets.chomp
if sort == "new"
    subreddit="https://www.reddit.com/r/#{subr}/new/.compact"
elsif sort == "top"
    print "Timespan [day/week/month/year/all]: "
    time = gets.chomp
    subreddit="https://www.reddit.com/r/#{subr}/top/.compact?sort=top&t=#{time}"
elsif sort == "custom"
    print "Input your custom search: "
    search = gets.chomp
    print "Sort by [new/hot/top]: "
    sort = gets.chomp
    print "Timespan [day/week/month/year/all]: "
    time = gets.chomp
    
    subreddit="https://www.reddit.com/r/#{subr}/search.compact?q=#{search}&restrict_sr=on&sort=#{sort}&t=#{time}"
end

docsubr = Nokogiri::HTML(open(subreddit))
threads = docsubr.xpath("//div[@class='content']/div[@id='siteTable']/div")

puts ""
puts "You're browsing... #{subreddit}"
puts ""
threads[0..-1].each do |tr|
    count+=1
    puts tr.at_css('p/a').text
    source = tr.at_css("p[@class='title']/a/@href")
    rlink = tr.at_css('@href')
    if source.content == rlink.content
        puts "Source: N/A (Self-post)"
    else
        puts "Source: #{source.text}"
    end
    puts "Reddit thread link: #{rlink.text}"
    puts tr.at_css("div[@class='commentcount']/a").text + " comments | " + 
         tr.at_css("/div[@class='entry unvoted']/div/span[1]/span")
    time = tr.at_css("/div[@class='entry unvoted']/div/span[1]/time")
    timeutc = tr.at_css("div[@class='entry unvoted']/div/span[1]/time/@title")
    puts "Time posted: #{time.text} | " + "#{timeutc.text}"
    puts""
end
puts "#{count} threads listed, sorted by #{sort}"
end #end of loop