# KM 9/5/17: this might not be needed since travis already does a bundle install
bundle install && bundle exec middleman build && bundle exec middleman s3_sync --environment=$1
