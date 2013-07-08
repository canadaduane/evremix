ngrams = ARGV[0].to_i
words = []
$stdin.each_line do |line|
  line.gsub!(/[^a-zA-Z \-]+/, '')
  # line.gsub!(/\d+:\d+/, '')
  # line.gsub!(/^\s*\d+\s*/, '')
  # line.gsub!(/[\?\!\-\.;:",\(\)]+/, ' ')
  words += line.downcase.split(/[\s\-]+/)
  while words.size >= ngrams
    ngram = words[0...ngrams].join(" ")
    puts ngram if ngram !~ /^\s*$/ and ngram[0] != ' '
    words.shift
  end
end

