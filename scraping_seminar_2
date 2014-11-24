require 'open-uri'
require 'nokogiri'
require 'sqlite3'
require 'json'
urls = []

db = SQLite3::Database.new('crawling_detail.db')
db.execute('CREATE TABLE IF NOT EXISTS seminars_detail (title varchar(100), image_url varchar(200), presenter varchar(200), presenter_detail varchar(300), seminars_contents varchar(1000), iine_count integer)')

(1650 .. 1699).each do |parameta|
  urls.push("https://www.goodfind.jp/2016/seminar/" + parameta.to_s)
end

urls.each_with_index do |url, index|
  charset = nil
  begin
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    # セミナータイトル
    doc = Nokogiri::HTML.parse(html, nil, charset)
    puts doc.css('title').text
    # メインイメージ
    puts doc.css('#detail_top > img').attr('src')
    img_url = doc.css('#detail_top > img').attr('src')
    full_img_url = "https://www.goodfind.jp/" + img_url
    # 登壇者&肩書き
    puts doc.css('#section_1 > div > p > span').text
    presenter = doc.css('#section_1 > div > p > span').text
    # 登壇者詳細
    puts doc.css('#section_2 > div > p > span').text
    presenter_detail = doc.css('#section_2 > div > p > span').text
    # セミナー詳細
    seminars_contents = doc.css('#section_1 > div').text
    # Facebookいいね
    response = open("http://graph.facebook.com/#{url}").read
    puts response
    json = JSON.parse(response)
    puts json
    if json["shares"]
      puts json["shares"].to_s
      iine = json["shares"].to_i
    end
      db.execute 'INSERT INTO seminars_detail values ( ?, ?, ?, ?, ?, ? );', ["#{doc.css('title').text}", "#{full_img_url}", "#{presenter}", "#{presenter_detail}", "#{seminars_contents}", iine]
  rescue
    puts "error"
  end
end
