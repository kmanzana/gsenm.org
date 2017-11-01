require 'dotenv/load'

set :url_root, 'http://gsenm.org'
activate :search_engine_sitemap
activate :dato, live_reload: true

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Helpers
helpers do
  def markdown(source)
    return '' unless source
    Tilt[:markdown].new { source }.render(self)
  end

  def preview(content)
    return '' if content.empty?
    text = content.find { |section| section.item_type.name == 'text' }
    return '' if text.nil?
    text.text.split.first(12).join(' ') + '...'
  end

  def format(date)
    date.strftime('%m.%d.%Y')
  end

  def product_custom_field_attributes(custom_fields)
    custom_fields.each_with_object({}).with_index(1) do |(field, attributes), index|
      attributes["item-custom#{index}-name"] = field.name
      attributes["item-custom#{index}-required"] = field.required
      attributes["item-custom#{index}-options"] = field.options
    end
  end
end

activate :google_analytics do |ga|
  ga.tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
end

# Configuration
activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

configure :development do
  config[:host] = 'http://localhost:4567'

  activate :livereload
end

configure :build do
  activate :asset_hash
  activate :gzip
  # activate :imageoptim # doesn't support MM4 https://github.com/plasticine/middleman-imageoptim/issues/46
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
end

# Proxy pages
# KM 8/26/17: due to how middleman 4 collections work (http://bit.ly/2jHZTI9),
# always use `dato` inside a `.tap` method block
dato.tap do |dato|
  dato.programs.each do |program|
    proxy "/programs/#{program.slug}.html", '/templates/program', locals: {
      program: program
    }, ignore: true
  end

  dato.news_posts.each do |news_post|
    proxy "/news/#{news_post.slug}.html", '/templates/news_post', locals: {
      news_post: news_post
    }, ignore: true
  end
end

configure :staging do
  config[:host] = 'http://staging.gsenm.org'

  activate :s3_sync do |s3_sync|
    s3_sync.bucket                     = 'staging.gsenm.org'
    s3_sync.region                     = 'us-west-2'
    s3_sync.aws_access_key_id          = ENV['AWS_ACCESS_KEY_ID']
    s3_sync.aws_secret_access_key      = ENV['AWS_SECRET_ACCESS_KEY']
    # s3_sync.prefix                     = ''
    s3_sync.index_document             = 'index.html'
    # s3_sync.error_document             = '404.html'
    # s3_sync.prefer_gzip                = true
  end

  caching_policy 'text/html', max_age: 0, must_revalidate: true
  default_caching_policy max_age:(60 * 60 * 24 * 365)
end

configure :production do
  config[:host] = 'http://gsenm.org'

  activate :s3_sync do |s3_sync|
    s3_sync.bucket                     = 'gsenm.org'
    s3_sync.region                     = 'us-west-2'
    s3_sync.aws_access_key_id          = ENV['AWS_ACCESS_KEY_ID']
    s3_sync.aws_secret_access_key      = ENV['AWS_SECRET_ACCESS_KEY']
    s3_sync.index_document             = 'index.html'
    # s3_sync.error_document             = '404.html'
  end

  caching_policy 'text/html', max_age: 0, must_revalidate: true
  default_caching_policy max_age:(60 * 60 * 24 * 365)
end

