class MainController < ApplicationController
  def home_page
    recents

    @limit = params[:limit] || 3

    @limit =(@limit.to_i > 50 ? 50 : @limit.to_i)
    if params[:id].nil?
      @video = Video.random
    else
      @video = Video.find(params[:id])
    end

    @p = Confreaks::ParseUserAgent.new

    @p.parse request.env["HTTP_USER_AGENT"]

    @player = params[:player] || "html5"

    @all_time = Video.find(:all,
                           :include => [:event],
                           :conditions => ['events.private = ? and available = ?',
                                          false, true],
                           :order => "views desc",
                           :limit => @limit)

    @last_7 = Video.find(:all,
                         :include => [:events],
                         :conditions => ['events.private = ? and available = ?',
                                         false, true],
                         :order => "views_last_7 desc",
                         :limit => @limit)

    @last_30 = Video.find(:all,
                          :include => [:events],
                          :conditions => ['events.private = ? and available = ?',
                                          false, true],
                          :order => "views_last_30 desc",
                          :limit => @limit)

  end

  def contact
    redirect_to '/contact-us', :status => 301
  end
end
