namespace :events do
  desc "check and attach uploaded videos"
  task :attach, [:short_code] => :environment do | t, args |
    if args[:short_code] == "all"
      events = Event.find(:all, :order => "short_code")
    else
      event = Event.find_by_identifier(args[:short_code])
      events = [event] unless event.nil?
    end

    events.each do |event|
      puts "Checking #{event.short_code}"
      # Check to see if a directory exists for the conference
      video_source_dir = "#{RAILS_ROOT}/../../../source/#{event.short_code}"
      if File.directory? video_source_dir
        puts "\tdirectory exists for this event."
        event.videos.each do |video|
          if video.assets.count == 0
            file = "#{@video.id}.mp4"
            puts "\t\tvideo #{video.id}/#{video.title} has no assets, checking for files."
            if File.exists?("#{video_source_dir}/#{file}")
              puts "\t\t\tfile exists, attaching..."

              full_file = "#{video_source_dir}/#{file}"

              if File.exists?(full_file)
                @asset = Asset.new do |a|
                  a.data = File.new(full_file)
                  a.asset_type_id = 1
                  a.description = "1920x1080"
                  video.assets << a
                end
                video.save

                # video is attached, now submit to zencoder

                @asset.data.url

                results, response = Confreaks::Encoder.submit_to_zencoder @asset
              else
                puts "\t\t\tno file exists."
              end
            end
          end
        end
      else
        puts "\tNo directory (#{video_source_dir}) exists for this event ."
      end
    end
  end
end
