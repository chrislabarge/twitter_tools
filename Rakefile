require 'yaml'
require_relative 'lib/twitter_wrapper'
include TwitterWrapper
# task default: %w[test]

# task :test do
#   ruby "test/unittest.rb"
# end

CONFIG_FILES = FileList['config/settings.yml']

def get_config(file)
  YAML.load_file(file)
end

CONFIG_FILES.each do |f|
  config = get_config(f)

  task :follow_users, [:limit] do |_, args|
    limit = args[:limit].to_i || 80

    client = Wrapper.new

    client.follow_creators_of_tweets_containing(config['terms'], limit)
  end
end
