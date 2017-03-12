class BookingsController < ApplicationController
	
	def index
	end

	def check_availability
		@booking = Booking.new
	end

	def new
		@booking = Booking.new
		book_from_date = params[:book_from]
		@book_from = Date.new book_from_date["{:class=>\"form-control\"}(1i)"].to_i, book_from_date["{:class=>\"form-control\"}(2i)"].to_i, book_from_date["{:class=>\"form-control\"}(3i)"].to_i
		
		book_to_date = params[:book_to]
		@book_to = Date.new book_to_date["{:class=>\"form-control\"}(1i)"].to_i, book_to_date["{:class=>\"form-control\"}(2i)"].to_i, book_to_date["{:class=>\"form-control\"}(3i)"].to_i

		@date_range = @booking.date_range(@book_from, @book_to)

		if current_user.nature_of_job == 'Flexible' && @date_range > 7 || current_user.nature_of_job == 'Project-Based' && @date_range > 179
			flash[:alert] = 'Duration too long!'
			redirect_back(fallback_location: check_availability_user_bookings_path)
			return false
		end

		@available_desks = @booking.available_desks(@book_from, @book_to)

		@desk_name = params[:desk_name]
	end

	def create
		@book_desk = @booking.book_desk(@book_from, @book_to, desk_name)
		@booking = Booking.new(booking_params)

		if @booking.save!
			flash[:notice] = 'Booking Successful!'
			redirect_to @booking
		else
			render :new
		end
	end

	def show
		@booking = Booking.find(params[:id])
	end

	def destroy
	end

	private

	def booking_params
		params.permit(:book_from, :book_to, :wing, :section, :number, :user_id, :id)
	end
end