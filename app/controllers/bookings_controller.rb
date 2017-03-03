class BookingsController < ApplicationController
	def index
		a = Booking.where(user_id: current_user.id).pluck(:book_from)
		(0..(a.length-1)).each do |i|
			@bookings_from = a[i]
		end

		b = Booking.where(user_id: current_user.id).pluck(:book_to)
		(0..(b.length-1)).each do |j|
			@bookings_to = b[j]
		end
	end

	def new
		@booking = Booking.new
	end

	def check_availability
		#check active bookings
		user_name = current_user.name
		user_id = current_user.id

		counter = 0

		Booking.all.each do |b|
			current_date = Date.today
			booked_start_date = b.book_from
			booked_end_date = b.book_to
			if b.user_id == current_user.id && current_date <= booked_end_date && booked_start_date <= current_date
				counter = counter + 1
			end
		end

		if counter > 1
			flash[:alert] = 'Too many active bookings!'
			redirect_back(fallback_location: book_user_bookings_path)
			return false
		end

		nature_of_job = current_user.nature_of_job

		book_from_date = params[:book_from]
		book_from = Date.new book_from_date["{:class=>%22form-control%22}(1i)"].to_i, book_from_date["{:class=>%22form-control%22}(2i)"].to_i, book_from_date["{:class=>%22form-control%22}(3i)"].to_i
		
		if Date.today > book_from
			flash[:alert] = 'Invalid Date!'
			redirect_back(fallback_location: book_user_bookings_path)
			return false
		end
		
		book_to_date = params[:book_to]
		book_to = Date.new book_to_date["{:class=>%22form-control%22}(1i)"].to_i, book_to_date["{:class=>%22form-control%22}(2i)"].to_i, book_to_date["{:class=>%22form-control%22}(3i)"].to_i

		duration = (book_to - book_from).to_i

		if current_user.nature_of_job == 'Flexible' && duration > 7 || current_user.nature_of_job == 'Project-Based' && duration > 179
			flash[:alert] = 'Duration too long!'
			redirect_back(fallback_location: book_user_bookings_path)
			return false
		end

		desk = []

		Desk.all.each do |e|
		f = e.wing
		g = e.section
		h = e.number
		j = f.to_s + g.to_s + h.to_s
		desk.push(j)
		end

		Booking.all.each do |k|
			booked_start_date = k.book_from
			booked_end_date = k.book_to
			desk_id = k.desk_id
			if book_from <= booked_end_date && booked_start_date <= book_to
				l = Desk.where(id: desk_id).pluck(:wing)
				ll = l[0]
				m = Desk.where(id: desk_id).pluck(:section)
				mm = m[0]
				n = Desk.where(id: desk_id).pluck(:number)
				nn = n[0]
				o = ll.to_s + mm.to_s + nn.to_s
				desk.delete(o)
			end
		end

		@available_desks = desk
		@booking_date = "#{book_from} - #{book_to}"
		@@book_from = book_from
		@@book_to = book_to

	end

	def book
		@booking = Booking.new
		user_name = current_user.name
		user_id = current_user.id

		desk_name = params[:desk_name]
		a = desk_name.split('')
		wing = a[0]
		section = a[1]
		number = a[2] 
		did = Desk.where(wing: wing, section: section, number: number).pluck(:id)
		desk_id = did[0]

		book_from = @@book_from
		book_to = @@book_to

		Booking.create(:user_name=>user_name, :user_id=>user_id, :book_from=>@@book_from, :book_to=>@@book_to, :desk_id=>desk_id)

		redirect_back(fallback_location: book_user_bookings_path)
	end

	 def create
      @booking = current_user.bookings.build(booking_params)
      if @booking.save
        flash[:success] = "Booking sucessful!"
        redirect_to @booking
      else
        render :book #'static_pages/home'
      end
    end

	def show

	end

	def destroy
	    redirect_to unauthenticated_root_path unless current_user

	    @booking = Booking.find(params[:id])
	    @booking.destroy

	end

	private

	def booking_params
		params.permit(:book_from, :book_to, :wing, :section, :number)
	end

end
