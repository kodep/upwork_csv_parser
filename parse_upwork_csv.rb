require 'rubygems'
require 'csv'
require 'google_drive'
require 'json'
require 'bigdecimal'

russian_month_names = { 1 => 'Январь',
                        2 => 'Февраль',
                        3 => 'Март',
                        4 => 'Апрель',
                        5 => 'Май',
                        6 => 'Июнь',
                        7 => 'Июль',
                        8 => 'Август',
                        9 => 'Сентябрь',
                        10 => 'Октябрь',
                        11 => 'Ноябрь',
                        12 => 'Декабрь' }

google_config = { client_id: ENV['GOOGLE_CLIENT_ID'],
                  client_secret: ENV['GOOGLE_CLIENT_SECRET'] }

res = {}
CSV.foreach("statement_20170101_20170630_all.csv", quote_char: '"', col_sep: ',', row_sep: :auto, headers: true) do |row|
  next unless row['Team']
  month_num = DateTime.parse(row['Date']).month
  res[month_num] = {} unless res[month_num]
  if res[month_num][row['Team']]
    res[month_num][row['Team']] += BigDecimal.new(row['Amount'])
  else
    res[month_num][row['Team']] = BigDecimal.new(row['Amount'])
  end
end

session = GoogleDrive::Session.from_config(google_config.to_json)
ss = session.spreadsheet_by_title(ENV['GOOGLE_SPREADSHEET_NAME']) || session.create_spreadsheet(title = ENV['GOOGLE_SPREADSHEET_NAME'])
ws = ss.worksheets[0]
vertical_pointer = 1
ws.delete_rows(1, ws.num_rows)
Hash[res.sort].each do |month,data|
  ws[vertical_pointer, 1] = russian_month_names[month]
  vertical_pointer += 1
  horizontal_pointer = 1
  ws[vertical_pointer, horizontal_pointer] = 'Проект'
  ws[vertical_pointer + 1, horizontal_pointer] = 'Сумма'
  data.each do |k,v|
    horizontal_pointer += 1
    ws[vertical_pointer, horizontal_pointer] = k
    ws[vertical_pointer + 1, horizontal_pointer] = "$#{v.to_f}"
  end
  vertical_pointer += 3
end

ws.save
