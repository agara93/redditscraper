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
if subr != 'all' || 'search'
    subdesc = docsubrm.at_css("/html/body/div[@class='container']/blockquote").text
end

if subr == 'search'
    puts ""
    puts "Reddit Search"
    puts "==============="
    print "Input your custom search: "
    search = gets.chomp
    print "Sort by [new/hot/relevance/top]: "
    sort = gets.chomp
    print "Timespan [day/week/month/year/all]: "
    time = gets.chomp
    
    subreddit = "https://www.reddit.com/search.compact?q=#{search}&sort=#{search}&t=#{time}"
    docsubr = Nokogiri::HTML(open(subreddit))
    sbresults = docsubr.xpath("//div[@class='content']/div[@id='siteTable'][1]/div")
    tresults = docsubr.xpath("//div[@class='content']/div[@id='siteTable'][2]/div")
    
    sbresults[0..-1].each do |sb|
        count+=1
        puts ""
        puts "[sb#{count}]"
        puts sb.at_css('p/a').text
        rlink = sb.at_css("p[@class='title']/a/@href")
        puts "Subreddit link: #{rlink}"
        puts sb.at_css("p[@class='title']/a[@class='domain']").text
        puts sb.at_css("p[@class='tagline']/span[@class='score unvoted']/span[@class='number']").text + " subscribers" +                    sb.at_css("p[@class='tagline']/text()").text
        puts ""
    end
    
    puts "#{count} subreddits listed"
    count = 0
    
    tresults[0..-1].each do |th|
        count += 1
        puts ""
        puts "[tr#{count}]"
        puts th.at_css('p/a').text
        slink = th.at_css("p[@class='title']/a/@href")
        rlink = th.at_css('@href')
        if slink.content == rlink.content
            puts "Source: N/A (Self-post)"
        else
            puts "Source: #{slink}"
        end
        puts "Reddit thread link: #{rlink.text}"
        puts th.at_css("div[@class='commentcount']/a").text + " comments | " +
             th.at_css("/div[@class='entry unvoted']/div/span[1]/span")
        time = th.at_css("/div[@class='entry unvoted']/div/span[1]/time")
        timeutc = th.at_css("div[@class='entry unvoted']/div/span[1]/time/@title")
        puts "Time posted: #{time.text} | " + "#{timeutc.text}"
        puts ""
    end
end

if subr != 'search'
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
        print "Sort by [new/hot/relevance/top]: "
        sort = gets.chomp
        print "Timespan [day/week/month/year/all]: "
        time = gets.chomp
        
        subreddit="https://www.reddit.com/r/#{subr}/search.compact?q=#{search}&restrict_sr=on&sort=#{sort}&t=#{time}"
    end

    docsubr = Nokogiri::HTML(open(subreddit))
    threads = docsubr.xpath("//div[@class='content']/div[@id='siteTable']/div")
    
    puts ""
    if subr == 'search'
        puts "Search result.. #{subreddit}"
    else
        puts "You're browsing... #{subreddit}"
    end
    puts ""
    threads[0..-1].each do |tr|
        count+=1
        puts "[#{count}]"
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
    end #end of threads loop
end #end of != search condition

puts "#{count} threads listed, sorted by #{sort}"
end #end of loop