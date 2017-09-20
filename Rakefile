task default: :deploy

task :deploy do
  def deploy_command(environment)
    "bundle exec middleman build --verbose && bundle exec middleman s3_sync --environment=#{environment} --verbose"
  end

  case `git symbolic-ref --short HEAD`.chomp
  when 'staging'
    system deploy_command('staging')
  when 'master'
    system deploy_command('production')
  end
end
