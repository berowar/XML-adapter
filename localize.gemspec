Gem::Specification.new do |s|
  s.name          = "localize"
  s.version       = "0.1"
  s.date          = "2010-05-06"

  s.summary       = "Lightweight localization library"
  s.description   = "Lightweight, ruby-way localization solution"

  s.author        = "Andrey Savchenko"
  s.email         = "andrey@aejis.eu"
  s.homepage      = "http://aejis.eu/tools/localize"
  
  s.files         = %w[
    LICENSE
    README.rdoc
    lib/localize.rb
    lib/localize/formats.rb
    lib/localize/sinatra.rb
    lib/localize/adapters/yaml.rb
    localize.gemspec
    test/formats_test.rb
    test/translate_test.rb
    test/stores/en.yml
  ]
  s.require_paths = %w[lib]

  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}

  s.has_rdoc = true
  s.extra_rdoc_files = %w[README.rdoc LICENSE]

  s.add_development_dependency 'rspec'
end