require 'sqlite3'
require 'csv'

# データベースを作成
db = SQLite3::Database.new('work4-1.db')

# id(数値),name(文字列),address(文字列)のカラムを生成
db.execute(%q{
  CREATE TABLE IF NOT EXISTS restaurants (
    id INTEGER,
    name TEXT,
    property TEXT,
    alphabet TEXT,
    name_kana TEXT,
    pref_id INTEGER,
    area_id INTEGER,
    station_id1 INTEGER,
    station_time1 INTEGER,
    station_distance1 INTEGER,
    station_id2 INTEGER,
    station_time2 INTEGER,
    station_distance2 INTEGER,
    station_id3 INTEGER,
    station_time3 INTEGER,
    station_distance3 INTEGER,
    category_id1 INTEGER,
    category_id2 INTEGER,
    category_id3 INTEGER,
    category_id4 INTEGER,
    category_id5 INTEGER,
    zip TEXT,
    address TEXT,
    north_latitude TEXT,
    east_longitude TEXT,
    description TEXT,
    purpose TEXT,
    open_morning INTEGER,
    open_lunch INTEGER,
    open_late INTEGER,
    photo_count INTEGER,
    special_count INTEGER,
    menu_count INTEGER,
    fan_count INTEGER,
    access_count INTEGER,
    created_on TEXT,
    modified_on TEXT,
    closed INTEGER
  );
})

open('dataset/restaurants.csv', 'r') do |file|

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
    db.execute %q{INSERT INTO restaurants (id, name, property, alphabet, name_kana, pref_id, area_id, station_id1, station_time1, station_distance1, station_id2, station_time2, station_distance2, station_id3, station_time3, station_distance3, category_id1, category_id2, category_id3, category_id4, category_id5, zip, address, north_latitude, east_longitude, description, purpose, open_morning, open_lunch, open_late, photo_count, special_count, menu_count, fan_count, access_count, created_on, modified_on, closed)
      values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? );},
      [
        csv_line['id'],
        csv_line['name'],
        csv_line['property'],
        csv_line['alphabet'],
        csv_line['name_kana'],
        csv_line['pref_id'],
        csv_line['area_id'],
        csv_line['station_id1'],
        csv_line['station_time1'],
        csv_line['station_distance1'],
        csv_line['station_id2'],
        csv_line['station_time2'],
        csv_line['station_distance2'],
        csv_line['station_id3'],
        csv_line['station_time3'],
        csv_line['station_distance3'],
        csv_line['category_id1'],
        csv_line['category_id2'],
        csv_line['category_id3'],
        csv_line['category_id4'],
        csv_line['category_id5'],
        csv_line['zip'],
        csv_line['address'],
        csv_line['north_latitude'],
        csv_line['east_longitude'],
        csv_line['description'],
        csv_line['purpose'],
        csv_line['open_morning'],
        csv_line['open_lunch'],
        csv_line['open_late'],
        csv_line['photo_count'],
        csv_line['special_count'],
        csv_line['menu_count'],
        csv_line['fan_count'],
        csv_line['access_count'],
        csv_line['created_on'],
        csv_line['modified_on'],
        csv_line['closed']
      ]
  end

  # insertを高速にする方法[1/2]
  db.execute 'COMMIT;'

end
