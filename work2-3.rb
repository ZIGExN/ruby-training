require 'sqlite3'
require 'csv'

# データベースを作成
db = SQLite3::Database.new('work2-3.db')

# id(数値),name(文字列),address(文字列)のカラムを生成
db.execute(%q{
  CREATE TABLE IF NOT EXISTS categories (
    id INTEGER,
    name TEXT,
    name_kana TEXT,
    parent1 INTEGER,
    parent2 INTEGER,
    similar TEXT
  );
})

open('dataset/categories.csv', 'r') do |file|

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
    db.execute %q{INSERT INTO categories (id, name, name_kana, parent1, parent2, similar)
      values ( ?, ?, ?, ?, ?, ? );},
      [
        csv_line['id'],
        csv_line['name'],
        csv_line['name_kana'],
        csv_line['parent1'],
        csv_line['parent2'],
        csv_line['similar'],
      ]
  end

  # insertを高速にする方法[1/2]
  db.execute 'COMMIT;'

end
