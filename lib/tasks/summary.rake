namespace :views do
  desc "update videos with total views"
  task :update => :environment  do |t|
    puts "Updating number of views for all videos"
    v = Video.find(:all)
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
  end
end
