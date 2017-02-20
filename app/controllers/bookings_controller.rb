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

		counter = 0

		Booking.all.each do |b|
			b.user_id == current_user.id
			counter = counter + 1
		end
		
		if counter > 500
			puts 'Too many bookings!'
		else

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

		e = params[:desk_id] || {}

		f = Booking.where(desk_id: e).pluck(:book_from)
		booked_start_date = f[0]
		g = Booking.where(desk_id: e).pluck(:book_to)
		booked_end_date = g[0]

		if (start_date - booked_end_date)*(booked_start_date - end_date) >=0
			puts 'overlap'
		elsif
			current_user.nature_of_job == 'Flexible' && duration < 8 || current_user.nature_of_job == 'Project-Based' && duration < 180
			Booking.create(:user_name=>user_name, :user_id=>user_id, :book_from=>book_from, :book_to=>book_to, :desk_id=>e)
		else
			puts "Duration too long!"
		end

		# f = Desk.where(id: e).pluck(:wing)
		# ff = f[0]
		# g = Desk.where(id: e).pluck(:section)
		# gg = g[0]
		# h = Desk.where(id: e).pluck(:number)
		# hh = h[0]
		# i = ff.to_s + gg.to_s + hh.to_s
		# puts i

		Desk.all.each do |d|

			# a = d.wing
			# b = d.section
			# c = d.number
			# d = a.to_s + b.to_s + c.to_s

			# if d == 'available'
			# 	puts 'available'
			# else
			# 	puts 'unavailable'
			# end
		end

		# e = params[:wing] || {}
		# f = e.values
		# wing = f[0]

		# g = params[:section] || {}
		# h = g.values
		# section = h[0]

		# i = params[:number] || {}
		# j = i.values
		# number = j[0]

		# desk_number = wing + section + number

		# puts desk_number
	end

	end

	def show
		@booking = Booking.find(params[:id])
	end

end
