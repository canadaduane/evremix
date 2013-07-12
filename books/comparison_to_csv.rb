require 'json'
require 'csv'

json = JSON.parse(File.read(ARGV[0]))

CSV.open(ARGV[1], "wb") do |csv|
  json.each do |record|
    # p record
    csv << [
      record['matches']["1"].to_f / record['words'] * 1000,
      record['matches']["2"].to_f / record['words'] * 1000,
      record['matches']["3"].to_f / record['words'] * 1000,
      record['matches']["4"].to_f / record['words'] * 1000,
      record['matches']["5"].to_f / record['words'] * 1000,
      record['matches']["6"].to_f / record['words'] * 1000,

      record['matches']['1'],
      record['matches']['2'],
      record['matches']['3'],
      record['matches']['4'],
      record['matches']['5'],
      record['matches']['6'],
      record['words'],
      record['book']
    ]
  end
end