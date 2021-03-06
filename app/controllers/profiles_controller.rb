class ProfilesController < ApplicationController
	def show
		id = params[:id]
		@profile = User.find(id)
	
	end

	def edit
		id = params[:id] 
		@profile = User.find(id)
		if current_user.id != @profile.id
		  render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404
	    end
	    @learning_style = ["Visual", "Auditory", "Kinesthetics"]
	end

	def update
		id = params[:id]
		profile = User.find(id)
		profile.update(profile_params)
		redirect_to profile_path(profile)
	end

	private
	def profile_params
		params.require(:profile).permit(:twitter_name, :github_name, :bio, :username, :learning_style, :avatar)
	end
end