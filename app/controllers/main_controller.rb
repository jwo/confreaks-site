class MainController < ApplicationController
  def home_page
    recents

    if params[:id].nil?
      @video = Video.random
    else
      @video = Video.find(params[:id])
    end

    @p = Confreaks::ParseUserAgent.new

    @p.parse request.env["HTTP_USER_AGENT"]

    @player = params[:player] || "html5"

    @all_time = Video.find(:all, :order => "views desc", :limit => 3)

    @last_7 = Video.find(:all, :order => "views_last_7 desc", :limit =>3)

    @last_30 = Video.find(:all, :order => "views_last_30 desc", :limit => 3)

  end

  def contact
    redirect_to '/contact-us', :status => 301
  end
end
