namespace :views do
  desc "update videos with total views"
  task :update => :environment  do |t|
    puts "Updating number of views for all videos"
    v = Video.find(:all)
    u = User.find_by_username("cobyr")
    a = Activity.new
    a.message = "update views"
    start_time = Time.now
    v.each do |video|
      puts "\tCalculating views for #{video.id} #{video.title}"
      video.views = History.count(:all, :conditions => {
                        :controller => 'videos',
                        :action => 'show',
                        :param_id => video.id }
                      )
      video.views_updated_at = Time.now
      video.save!
    end
    end_time = Time.now
    a.message = "Updated views took #{end_time - start_time}."
    a.save
  end

  desc "update videos with last 7 and 30 day views"
  task :update_periods => :environment do |t|
    puts "Updating number of views for all videos"
    v = Video.find(:all)
    u = User.find_by_username("cobyr")
    a = Activity.new
    a.message = "update views"
    start_time = Time.now
    v.each do |video|
      puts "\tCalculating views for #{video.id} #{video.title}"
      video.views = History.count(:all, :conditions => {
                        :controller => 'videos',
                        :action => 'show',
                        :param_id => video.id }
                      )
      puts "\t\t7 days"
      video.views_last_7 = History.count(:all, :conditions => {
                        :controller => 'videos',
                        :action => 'show',
                        :param_id => video.id,
                        :created_at => ">= #{Time.now - (86400*7)}"
                                         }
                      )

      puts "\t\t30 days"
      video.views_last_30 = History.count(:all, :conditions => {
                        :controller => 'videos',
                        :action => 'show',
                        :param_id => video.id,
                        :created_at => ">= #{Time.now - (86400*30)}"
                                          }
                      )


      video.views_updated_at = Time.now
      video.save!
    end
    end_time = Time.now
    a.message = "Updated views took #{end_time - start_time}."
    a.save








end
