class Admin::EventsController < Admin::Controller
  layout  'admin'

  def index
    if session.user && session.user.admin?
      @events = Event.paginate(:all,
                               :order => 'start_at desc',
                               :page => params[:page])
    else
      @events = Event.active.paginate(:all,
                                      :order => 'start_at desc',
                                      :page => params[:page])
    end
  end

  def new
    @event = Event.new
    @conferences = Conference.find(:all, :order => 'name')
  end

  def edit
    @event = Event.find_by_identifier(params[:id])
    @conferences = Conference.find(:all, :order => 'name')
  end

  def show
    event = Event.find_by_identifier(params[:id])
    redirect_to event_path(event)
  end

  def create
    @event = Event.create params[:event]

    redirect_to events_path
  end

  def update
    @event = Event.find_by_identifier(params[:id])

    @event.attributes = params[:event]

    if @event.save
      flash[:success]="Event changes saved successfully."
    else
      flash[:error]="Event changes could not be saved: " +
        @event.errors.full_messages.to_sentence
    end

    redirect_to events_path
  end

  def destroy
    @event = Event.find(params[:id])

    if @event.destroy
      flash[:success]="Event successfully deleted from the system."
    else
      flash[:error] = "Failed to delete the event: " + 
        @event.errors.full_messages.to_sentence
    end

    redirect_to admin_events_path
  end
end
