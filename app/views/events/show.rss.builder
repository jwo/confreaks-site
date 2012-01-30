xml.instruct! :xml, :version => "1.0" 
xml.rss(:version => "2.0", "xmlns:media" => 'http://search.yahoo.com/mrss/') do
  xml.channel do
    xml.title "#{@event.display_name}"
    xml.description "Available Videos from #{@event.display_name}"
    xml.link "http://confreaks.com#{event_path(@event)}"

    @event.videos.each do |video|
      xml.item do
        xml.title video.title
        xml.description video.abstract
        xml.pubDate video.recorded_at.strftime("%a, %d %b %Y %H:%M:%S %z")
        xml.link "http://confreaks.com#{video_path(video)}"
        xml.guid "http://confreaks.com#{video_path(video)}"
        video.assets.each do |asset|
          xml.media :title, asset.display_description
          xml.media :content,  :url => "#{ActionController::Base.asset_host}#{asset.data.url}"
        end
      end
    end
  end
end

