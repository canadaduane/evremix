
DIR = File.dirname(__FILE__)
folder = ARGV[0]
to_txt_cmd = File.join(DIR, 'epub-to-txt.rb')

Dir.glob(File.join(folder, '*.epub')) do |file|
  file_no_epub = file.sub(/\.epub$/, '')
  txtfile = file_no_epub + '.txt'
  cmd = "ruby #{to_txt_cmd} #{file} >#{txtfile}"
  puts cmd
  `#{cmd}`
end