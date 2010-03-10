Gem::Specification.new do |s|
  s.name          = "localize"
  s.version       = "0.1"
  s.date          = "2010-03-09"

  s.summary       = "Lightweight localization library"
  s.description   = "Lightweight, ruby-way localization solution"

  s.author        = "Andrey Savchenko"
  s.email         = "andrey@aejis.eu"
  s.homepage      = "http://aejis.eu/tools/localize"
  
  s.files         = %w[
    README.rdoc
    lib/localize.rb
    lib/localize/formats.rb
    lib/localize/adapters/yaml.rb
    localize.gemspec
    test/formats_test.rb
    test/translate_test.rb
    test/stores/en.yml
  ]
  
  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}
end