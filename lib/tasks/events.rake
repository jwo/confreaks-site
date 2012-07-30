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
      video_source_dir = "/home/deploy/source/#{event.short_code}"
      if File.directory? video_source_dir
        puts "\tdirectory exists for this event."
        event.videos.each do |video|
          if video.assets.count == 0
            if File.exists?("#{video_source_dir}/#{video.id}.mp4")
              puts "\t\tvideo #{video.id}/#{video.title} has no assets, checking for files."
              puts "\t\t\tfile exists."
            end
          end
        end
      else
        puts "\tNo directory exists for this event."
      end
    end
  end
end
