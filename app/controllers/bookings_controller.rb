class BookingsController < ApplicationController
	def index
		@bookings = Booking.all
	end

	def new
		@booking = Booking.new
	end

	def show
		@booking = Booking.find(params[:id])
	end

	private

	def desk_params
		params.require(:booking).permit(:user_name, :book_from, :book_to)
	end
end
