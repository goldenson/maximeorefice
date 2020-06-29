require 'yaml'

task :generate_cover_name do
  puts '📚 Generating cover name ...'

  image = Dir["assets/images/covers/1.jpg"].first
  raise "Image must be called 1.jpg" if image.nil?

  books = YAML::load_file(File.join('_data/books.yml'))
  title = books.first['title']
  cover_name = title.gsub("\'","-").split.map(&:downcase).join("-")

  image = Dir["assets/images/covers/1.jpg"].first
  File.rename(image, "assets/images/covers/#{cover_name}.jpg")

  puts "✅ #{image} has been renamed to assets/images/covers/#{cover_name}.jpg"
end
