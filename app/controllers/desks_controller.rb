class DesksController < ApplicationController
	def index
		@desks = Desk.all
	end

	def new
		redirect_to root_path unless current_user
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
