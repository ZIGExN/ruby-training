require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sinatra'

get '/view_seminar' do
  robotex = Robotex.new
  p robotex.allowed?("http://www.yahoo.co.jp/")

  url = 'http://www.yahoo.co.jp/'
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  charset = nil
  html = open(url, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  html = "<h1>ヤフーニュース一覧</h1>"

  doc.css('#topicsfb > div.topicsindex > ul.emphasis > li > a').each { |a_tag|
  # 文字列の中で文字列を扱うとき
  html << "<p><a href=#{a_tag.attr('href')}>#{a_tag.text}</span></a></p>"
 }

  # 整形したHTMLを出力する
  return html
end
