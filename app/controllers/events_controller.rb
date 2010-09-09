require 'rdiscount'

class EventsController < ApplicationController

  def index
    @events = Event.find(:all, :order => 'start_at desc')
    render :layout => 'admin'
  end

  def show
    @event = Event.find_by_identifier(params[:id])

    unless @event.ready  && params[:go]
      redirect_to "http://#{@event.short_code}.confreaks.com", :status => 302
    end
  end
end
