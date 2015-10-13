#http,https,ftp wrapper
require 'open-uri'
#gem required for scraping the web page
require 'nokogiri'

loop do

count=0

puts " "
puts "======================="
puts "Reddit Build-a-PC Sales"
puts "======================="
puts " "

#prompts the user to choose which type of listing method that will be displayed
print "What deals you want to see [recent/popular/custom]? "
deals = gets.chomp

case deals
    when "recent"
    
    #fetching the url page that will be scraped
    docnew = Nokogiri::HTML(open("https://www.reddit.com/r/buildapcsales/new/.compact"))
    docnew.remove_namespaces!
    newsales = docnew.xpath("//div[@class='content']/div[@id='siteTable']/div")
    
    puts " "
    puts "5 recent deals"
    puts "=============="
    puts " "

    newsales[0..4].each do |nw|
        count+=1
        puts nw.at_css('p/a').text
        slink = nw.at_css("p[@class='title']/a/@href")
        rlink = nw.at_css('@href')
        if slink.content == rlink.content
            puts "Store link: N/A (Self-post)"
        else
            puts "Store link: #{slink.text}"
        end
        puts "Reddit thread link:  #{rlink.text}"
        puts nw.at_css("div[@class='commentcount']/a").text + " comments | " + 
         nw.at_css("/div[@class='entry unvoted']/div/span[1]/span")
        time = nw.at_css("/div[@class='entry unvoted']/div/span[1]/time")
        timeutc = nw.at_css("div[@class='entry unvoted']/div/span[1]/time/@title")
        puts "Time posted: #{time.text} | " + "#{timeutc.text}"
        puts " "
    end
    
    when "popular"
    
    dochot = Nokogiri::HTML(open("https://i.reddit.com/r/buildapcsales"))
    dochot.remove_namespaces!
    hotsales = dochot.xpath("//div[@class='content']/div[@id='siteTable']/div")
    
    puts " "
    puts "Popular Deals"
    puts "============="
    puts " "
    hotsales[1..-1].each do |sl|
        count+=1
        puts sl.at_css('p/a').text
        slink = sl.at_css("p[@class='title']/a/@href")
        rlink = sl.at_css('@href')
        if slink.content == rlink.content
            puts "Store link: N/A (Self-post)"
        else
            puts "Store link: #{slink.text}"
        end
        puts "Reddit thread link:  #{rlink.text}"
        puts sl.at_css("div[@class='commentcount']/a").text + " comments | " + 
        sl.at_css("/div[@class='entry unvoted']/div/span[1]/span")
        time = sl.at_css("/div[@class='entry unvoted']/div/span[1]/time")
        timeutc = sl.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
        puts "Time posted: #{time.text} | " + "#{timeutc.text}"
        puts " "
    end
    when "custom"
        puts " "
        #prompts the user to enter the search keyword
        print "Input your custom search: "
        search = gets.chomp
        puts " "
        #prompts the user to choose the sort method
        #new = latest, hot = popular/comments, relevance = self explanatory, top = karma points/upvotes
        print "Sorted by [new/hot/relevance/top]: "
        sort = gets.chomp
        puts " "
        print "Timespan [day/week/month/year/all]: "
        time = gets.chomp
        puts " "
        
        #applying the "parameters" into the search link "query"
        srchlink = "https://www.reddit.com/r/buildapcsales/search.compact?q=#{search}&restrict_sr=on&sort=#{sort}&t=#{time}"
        docsrch = Nokogiri::HTML(open(srchlink))
        #xpath root 
        srchsales = docsrch.xpath("//div[@class='content']/div[@id='siteTable']/div")
        
        puts " "
        
        puts "Search result for #{search}"
        puts "[#{srchlink}]"
        puts "Sorted by #{sort}"
        puts "========================="
        puts " "
        srchsales[1..-1].each do |sr|
            count+=1
            puts sr.at_css('p/a').text
            slink = sr.at_css("p[@class='title']/a/@href")
            rlink = sr.at_css('@href')
            if slink.content == rlink.content
                puts "Store link: N/A (Self-post)"
            else
                puts "Store link: #{slink.text}"
            end
            puts "Reddit thread link:  #{rlink.text}"
            puts sr.at_css("div[@class='commentcount']/a").text + " comments | " + 
            sr.at_css("/div[@class='entry unvoted']/div/span[1]/span")
            time = sr.at_css("/div[@class='entry unvoted']/div/span[1]/time")
            timeutc = sr.at_css("/div[@class='entry unvoted']/div/span[1]/time/@title")
            puts "Time posted: #{time.text} | " + "#{timeutc.text}"
            puts " "
    end
    else
        puts "Invalid choice"
end
#total amount of search result
puts "#{count} sales found"
puts " "

end #loop end
