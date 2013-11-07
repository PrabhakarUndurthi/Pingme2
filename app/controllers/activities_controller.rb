class ActivitiesController < ApplicationController
  def index
    params[:page] ||= 1
    @activities = Activity.for_user(current_user, params)
  end
end
