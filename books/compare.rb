#!/usr/bin/env ruby

def parse_weighted_phrase(line)
  if line
    weight, *words = line.strip.split(" ")
    baseline_phrase = words.join(" ")
    [weight.to_i, baseline_phrase.strip]
  else
    [nil, nil]
  end
end

file = File.open(ARGV.first)
e1 = file.gets.strip
if e2 = STDIN.gets
  weight, baseline_phrase = parse_weighted_phrase(e2)
end

# Loop through 2 streams of sorted text data, and join on matching
# phrases. Assumes that the 2nd stream's first column is a weight value
# (frequency count) for the phrase.
if e1 && e2
  catch(:done) do
    loop do
      # puts "1 #{e1} #{baseline_phrase}"
      while e1 && e1 <= baseline_phrase
        if line = file.gets
          e1 = line.strip
        else
          throw :done
        end
      end
      # puts "2 #{e1} #{baseline_phrase}"
      while e1 && e2 && baseline_phrase < e1
        if e2 = STDIN.gets
          weight, baseline_phrase = parse_weighted_phrase(e2)
        else
          throw :done
        end
      end 
      puts "#{'%09d' % weight} #{e1}"
    end
  end
end

