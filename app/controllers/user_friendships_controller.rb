
	class UserFriendshipsController < ApplicationController
		before_filter :authenticate!, only: [:new]
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
		       @user_friendship = current_user_friendships.new(friend:@friend)
		       @user_friendship.save
		       flash[:success] = "You are now friends with #{@friend.full_name}"
		       redirect_to profile_path(@friend)
			else
				flash[:error] = "Friend required"
			end

			should "redirect to the site root" do
				assert_redirected_to root_path
			end

		  context "with a valid friend_id"do
		    setup do
		    	post :create,friend_id: users(:zuke)
		    end

		    should"assign a friend object"do
		      assert assigns(:friend)
		     end
		   end
		 end
	   end
	    
	  
	 
