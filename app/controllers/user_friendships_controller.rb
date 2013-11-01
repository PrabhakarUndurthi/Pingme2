
	class UserFriendshipsController < ApplicationController
		before_filter :authenticate!
		respond_to :html, :json

		def index
			@user_friendship = current_user.user_friendship.all
			respond_with @user_friendships
		end
		def accept
			@user_friendship = current_user.user_friendship.find(params[:id])
			redirect_to user_friendship_path
			if @user_friendship.accepted!
				flash[:success] = "You are now friends with #{@user_friendship.friend.first_name}"
			else
				flash[:error] = "That friendship could not be accepted"
		end
		redirect_to user_friendship_path
	end

	

			def new
				if  params[:friend_id]
					@friend = User.where(profile_name: params[:friend_id]).first
					raise ActiveRecord::RecordNotFound if @friend.nil?
					#@friend = User.find(params[:friend_id])
		            @user_friendship = current_user.user_friendships.new(friend: @friend)
					#@user_friendship = current_user_friendships.new(friend: @friend)
				else
					flash[:error] = "Friend required"
				end	
			rescue ActiveRecord::RecordNotFound
				render file: 'public/404', status: :not_found
			end


		def create

			if  params [:user_friendship] && params[:user_friendship].has_key?(:friend_id)
		       @friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
		       @user_friendship = UserFriendship.request(current_user,@friend)
		       respond_to do |format|
		         if  @user_friendship.new_record?
		         	format.html do
		              flash[:error] = "There was a problem in sending that friend request"
		              redirect_to profile_path(@friend)
		         end
		         format.json {render json: @user_friendship.to_json, status: :precondition_failder}

		     else
			   format.html do
		   	     flash[:success] = "Friend request sent."
		          redirect_to profile_path(@friend)
		      end
		   end


		       redirect_to profile_path(@friend)
			else
				flash[:error] = "Friend required"
			end
		  end
		def edit
			@friend = User.where(profile_name: params[:id]).first
			@user_friendship = current_user.user_friendships.where(friend_id: @friend.id).first.decorate
		end
	  end

			should "redirect to the site root" do
				assert_redirected_to root_path
			end

		  context "with a valid friend_id"do
		    setup do
		    	#post :create,friend_id: users(:zuke)
		    	post :create, friend_id: users(:zuke).profile_name
		    end
		 

		    should"assign a friend object"do
		       assert assigns(:friend)
		     end
		   end
		end
     end
  end

		 
	    
	  
	 
