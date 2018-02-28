require 'dotenv/load'
require 'yaml'
require 'tty-spinner'
require_relative 'lib/twitter_wrapper'
require 'rspec/core/rake_task'
include TwitterWrapper

# task default: %w[test]

# task :test do
#   ruby "test/unittest.rb"
# end
RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  task.pattern    = 'spec/**/*_spec.rb'
end

CONFIG_FILES = FileList['config/settings.yml']
spinner = TTY::Spinner.new(format: :pong)

def get_config(file)
  YAML.load_file(file)
end

CONFIG_FILES.each do |f|
  config = get_config(f)

  task :follow_users, [:limit] do |_, args|
    spinner.auto_spin

    limit = args[:limit].to_i || 80
    client = Wrapper.new

    client.process_tweets_containing(config['terms'], :follow, limit)

    spinner.success
  end

  task :favorite_tweets, [:limit] do |_, args|
    spinner.auto_spin

    limit = args[:limit].to_i || 80
    client = Wrapper.new

    client.process_tweets_containing(config['terms'], :favorite, limit)
    spinner.success
  end
end
