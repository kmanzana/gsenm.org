bundle install
bundle exec middleman build
bundle exec middleman s3_sync --environment=$1
