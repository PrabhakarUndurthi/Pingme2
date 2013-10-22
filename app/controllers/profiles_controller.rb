class ProfilesController < ApplicationController
  def show
    @user = User.find_by_profile_name(params[:id])
    if @user
      @statuses = @user.statuses.all
      render action: :show
    else
      render file: 'public/404', status:404, formats:[:html]
  	#If the profile page  not found ,then it return the user to the 404 
  	#erro page in HTML format.
  	  end
   end 
 end


