require 'json'

PWD = File.dirname(__FILE__)

def compare_book(path)
  begin
    words = Integer(`cat "#{path}.txt" | wc -w`.strip)
  rescue ArgumentError => e
    words = nil
  end

  info = {:book => path, :words => words}

  compare_script = File.join(PWD, "compare.sh")
  for n in [1, 2, 3, 4, 5, 6]
    cmd = %{#{compare_script} "#{path}" #{n}}
    begin
      result = Integer(`#{cmd} | wc -l`.strip)
    rescue ArgumentError => e
      result = nil
      puts e, path
    end
    info[:matches] ||= {}
    info[:matches][n] = result
  end
  info
end

books = []
count = 1
Dir.glob("*") do |path|
  if File.directory?(path) && File.exist?(File.join(path, "1-grams.txt"))
    $stderr.write "#{count}: #{path}\n"
    book = compare_book(path)
    books << book
    count += 1
    puts JSON::pretty_generate(book)
  end
end

