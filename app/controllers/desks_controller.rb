class DesksController < ApplicationController
	before_filter :authenticate_user!
 	before_filter do 
    	redirect_to new_user_session_path unless current_user && current_user.admin?
  	end

  	def admin?
  		self.admin == true
	end

	def index
		@desks = Desk.all
	end

	def new
		@desk = Desk.new
	end

	def create
		@desk = Desk.new(desk_params)

		if @desk.save
			flash[:notice] = 'Desk successfully created!'
			redirect_to @desk
		else
			render :new
		end
	end

	def show
		@desk = Desk.find(params[:id])
	end

	def destroy
		@desk = Desk.find(params[:id])
		@desk.destroy
	end

	private

	def desk_params
		params.require(:desk).permit(:desk_type, :status, :wing, :section, :number)
	end
end
