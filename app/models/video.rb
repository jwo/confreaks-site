class Video < ActiveRecord::Base

  attr_accessible :available, :title, :recorded_at, :event_id,
    :presentations_attributes, :assets_attributes, :include_random,
    :streaming_asset_id, :image, :abstract, :announce, :announce_date,
  :post_date, :note, :rating, :youtube_code, :license, :attribution,
  :use_event_note_for_attribution

  validates_presence_of :title
  validates_presence_of :recorded_at

  belongs_to :event

  belongs_to :streaming_video,
             :class_name => 'Asset',
             :foreign_key => "streaming_asset_id"

  has_many :assets

  has_many :presentations

  has_many :presenters, :through => :presentations

  accepts_nested_attributes_for :presentations,
    :reject_if => lambda { |a| a[:presenter_id].blank? },
    :allow_destroy => true

  accepts_nested_attributes_for :assets,
    :reject_if => lambda { |a| a[:asset_type_id].blank? },
    :allow_destroy => true

  has_attached_file :image,
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
    :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
    :styles => {
      :thumb => '180x101',
      :preview => '640x360'
    },
  :default_url => '/system/:class/:attachment/missing-:style.png'

  named_scope :available, 
                :joins => 'INNER JOIN events ON videos.event_id = events.id',
                :conditions => ['videos.available = ? and events.private = ? ', 
                                true, false]

  cattr_reader :per_page


  LICENSES = [ "cc-by-sa-3.0", "cc-by-nc-sa-2.0-uk" ]
  
  RATINGS = [ "Not yet Rated", "Everyone", "Language", "Strong Language" ]

  @@per_page = 25

  def self.search(search, all = "1")
    if all == "1"
      if search
        search_results = self.find(:all,
                       :joins => 'INNER JOIN events ON events.id = videos.event_id',
                       :conditions => ['videos.title like ? and events.private = ?',
                                       "%#{search}%", false],
                       :order => 'post_date desc')
      else
        search_results = self.find(:all, :order => 'post_date desc')
      end
    else
      if search
        search_results = available.find(:all,
             :conditions => ['title like ?', "%#{search}%"],
             :order => 'post_date desc')
      else
        search_results = available.find(:all, :order => 'post_date desc')
      end
    end

    final_results = search_results.select{ |v| v.event.ready? }

    puts "SR: #{search_results.count} | FR: #{final_results.count}"

    return final_results
  end

  def self.random
    if Rails.env == "production" || Rails.env == "development"
      order = 'rand()'
    else
      order = 'random()'
    end

    random_video = Video.first(:include => [:event],
                               :conditions => ["streaming_asset_id is not null and available = ? and recorded_at >= ? and events.ready = ? and events.private = ?", true, Date.today - 180, true, false],
                               :order => order)

    return random_video
  end

  def license_title
    case self.license
    when "cc-by-sa-3.0"
      "Creative Commons Attribution ShareAlike 3.0"
    when "cc-by-nc-sa-2.0-uk"
      "Creative Commons Attribution-NonCommercial-ShareAlike 2.0 UK: England & Wales"
    end
  end
  
  def license_url
    case self.license
    when "cc-by-sa-3.0"
      "http://creativecommons.org/licenses/by-sa/3.0/"
    when "cc-by-nc-sa-2.0-uk"
      "http://creativecommons.org/licenses/by-nc-sa/2.0/uk/"
    end
  end

  def license_image_file_url
    case self.license
    when "cc-by-sa-3.0"
      "http://i.creativecommons.org/l/by-sa/3.0/80x15.png"
    when "cc-by-nc-sa-2.0-uk"
      nil
    end
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    parts = Array.new
    parts << event.short_code
    parts << title.parameterize.to_s
    parts.join("-")
  end

  def streaming_video_url
    # TODO figure out how to remove the need for this stupid hack
    # paperclip adds the cache buster to the URL automatically, I need
    # it to go away, probably a really easy paperclip option, but not
    # finding it at the moment.
    unless streaming_video.nil?
      streaming_video.data.url.split("?")[0]
    else
      nil
    end
  end

  def display_presenters
    out = ""
    self.presenters.each do |p|
      out += p.display_name + ", "
    end
    out = out[0,out.length-2]
  end

  def display_twitter_presenters
    out = []
    self.presenters.each do |p|
      if p.twitter_name.nil?
        out << p.display_name
      else
        out << (p.twitter_name[0..0] == "@" ? p.twitter_name : "@#{p.twitter_name}")
      end
    end
    out.join(", ")
  end

  def views_for days = 0
    case days
    when 7
      views_last_7
    when 30
      views_last_30
    else
      views
    end
  end
end

