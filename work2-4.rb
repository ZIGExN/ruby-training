require 'sqlite3'
require 'csv'

# データベースを作成
db = SQLite3::Database.new('work4-3.db')

# id(数値),name(文字列),address(文字列)のカラムを生成
db.execute(%q{
  CREATE TABLE IF NOT EXISTS stations (
    id INTEGER,
    pref_id INTEGER,
    name TEXT,
    name_kana TEXT,
    property TEXT,
    similar TEXT
  );
})

open('dataset/stations.csv', 'r') do |file|

  header = CSV.parse_line(file.gets.chomp)

  # insertを高速にする方法[1/2]
  db.execute 'BEGIN;'

  while line = file.gets
    begin
      line_array = CSV.parse_line(line.chomp)
    rescue CSV::MalformedCSVError
    end

    csv_line = Hash[header.zip(line_array)]


    # データを追加する
    db.execute %q{INSERT INTO stations (id, pref_id, name, name_kana, property, similar)
      values ( ?, ?, ?, ?, ?, ? );},
      [
        csv_line['id'],
        csv_line['pref_id'],
        csv_line['name'],
        csv_line['name_kana'],
        csv_line['property'],
        csv_line['similar'],
      ]
  end

  # insertを高速にする方法[1/2]
  db.execute 'COMMIT;'

end
