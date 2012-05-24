require 'ostruct'

raw_config = File.read(RAILS_ROOT + "/config/youtube_it.yaml")
YouTubeItConfig = OpenStruct.new(YAML.load(raw_config)[Rails.env])
