task default: :deploy

task :deploy do
  def deploy_command(environment)
    "bundle exec middleman build --verbose && bundle exec middleman s3_sync --environment=#{environment} --verbose"
  end

  branch = `echo $TRAVIS_BRANCH`.chomp
  puts "current branch: #{branch}"

  case branch
  when 'staging'
    puts 'running deploy to env: staging'
    system(deploy_command('staging')) || raise('staging deploy failed')
  when 'master'
    puts 'running deploy to env: production'
    system(deploy_command('production')) || raise('production deploy failed')
  else
    puts 'not running deploy'
  end
end
