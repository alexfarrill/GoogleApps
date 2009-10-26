require 'echoe'

Echoe.new('GoogleApps', '0.1.0') do |p|
  p.description    = "Use the GoogleApps API"
  p.url            = "http://github.com/alexfarrill/GoogleApps"
  p.author         = "Alex Farrill"
  p.email          = "alex.farrill@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

task :default do
  cmd = "cd test_rails_app && rake"
  puts `#{cmd}` 
end
