class Admin::ActivitiesController < ApplicationController
  layout "admin"

  def index
    @activities = Activity.paginate(:all,
                                    :order => 'created_at desc',
                                    :page => params[:page])
  end

end
