require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/view_seminar' do

  db = SQLite3::Database.new('crawling_detail.db')
  db.results_as_hash = true

  html = '<h1>goodfind人気セミナー一覧</h1>'

  keyword = params[:keyword]
  if keyword != nil
    seminars = db.execute('SELECT * FROM seminars_detail where seminars_contents like ?;', "%#{keyword}%")
  else
    seminars = db.execute('SELECT * FROM seminars_detail ORDER BY iine_count DESC;')
  end

  html << %Q|
    <hr>
    <p>検索フォーム</p>
    <form>
      <input name="keyword">
      <input type="submit" value="送信">
    </form>
    <p>検索結果::#{seminars.count}件</p>
    <hr>
    |

  seminars.each  do |row|
    html << %Q|
      <div>
        <h2>#{row["title"]}　　いいね×#{row["iine_count"]}</h2>
        <img src = #{row['image_url']} width='480px'>
        <h3>詳細情報</h2>
        <div>#{row["presenter"]}</div>
        <h3>登壇者情報</h2>
        <div>#{row["presenter_detail"]}</div>
        <h3>セミナー情報詳細</h3>
        <p>
          #{row["seminars_contents"]}
        </p>
      </div>
    |
  end

  return html
end
