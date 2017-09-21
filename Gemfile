source 'https://rubygems.org'

ruby '2.4.1'

gem 'font-awesome-sass'
gem 'middleman'
gem 'middleman-autoprefixer'
gem 'middleman-dato'
gem 'middleman-livereload' # KM 8/26/17: can't be put in a group or it breaks
gem 'middleman-minify-html'
gem 'middleman-pry' # KM 4/14/17: can't be put in a group or it breaks
gem 'middleman-s3_sync'
gem 'mime-types'
gem 'rake'

group :development do
  gem 'dotenv'
  gem 'travis'

  # windows specific gems
  gem 'tzinfo-data', platforms: [:mswin, :mingw, :jruby]
  gem 'wdm', '~> 0.1', platforms: [:mswin, :mingw]
end
