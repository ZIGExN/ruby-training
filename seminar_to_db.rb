equire 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sqlite3'

robotex = Robotex.new
p robotex.allowed?("https://www.goodfind.jp/2016/seminar/")

db = SQLite3::Database.new('scraping_2.db')
db.execute('CREATE TABLE IF NOT EXISTS seminars (title varchar(100), title_url varchar(100), sub_title varchar(200));')

url = "https://www.goodfind.jp/2016/seminar/"
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'

charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

doc.css("#toggle_view_section > div.toggle.list_view > div > div > ul > li > a").each do |title|
  main_title = title.css("div.seminar_desc > h3").text
  sub_title = title.css("div.seminar_desc > p").text
  title_url = title.attr("href")
  db.execute 'INSERT INTO seminars values ( ?, ?, ? );', ["#{main_title}", "#{title_url}", "#{sub_title}"]
end
