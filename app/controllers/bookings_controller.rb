class BookingsController < ApplicationController
	def index
		@bookings = Booking.all
	end

	def new
		@booking = Booking.new
	end

	def book
		user_name = current_user.name
		user_id = current_user.id
		nature_of_job = current_user.nature_of_job

		a = params[:book_from] || {}
		b = a.values
		book_from = b[2] + '/' + b[1] + '/' + b[0]

		c = params[:book_to] || {}
		d = c.values
		book_to = d[2] + '/' + d[1] + '/' + d[0]

		start_date = Date.parse(book_from)
		end_date = Date.parse(book_to)
		duration = (end_date - start_date).to_i

		if current_user.nature_of_job == 'Flexible' && duration < 8 || current_user.nature_of_job == 'Project-Based' && duration < 180

		Booking.create(:user_name=>user_name, :user_id=>user_id, :book_from=>book_from, :book_to=>book_to)

		else
			puts "too long"
		end

		e = params[:wing] || {}
		f = e.values
		wing = f[0]

		g = params[:section] || {}
		h = g.values
		section = h[0]

		i = params[:number] || {}
		j = i.values
		number = j[0]

		desk_number = wing + section + number

		puts desk_number

		# counter = {}

		# Booking.all.each do |b|
		# 	if b.user_id == current_user.id
		# 		puts "true"
		# 	else
		# 		puts "false"
		# 	end
		# end
	end

	def show
		@booking = Booking.find(params[:id])
	end

end
