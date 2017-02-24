class Booking < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :desk, optional: true
	accepts_nested_attributes_for :desk, allow_destroy: true
	cattr_accessor :current_user

	def self.today_desk
		Booking.all.each do |k|
			booked_start_date = k.book_from
			booked_end_date = k.book_to
			desk_id = k.desk_id
			current_date = Date.today
			if (current_date - booked_end_date)*(booked_start_date - current_date) >=0
				l = Desk.where(id: desk_id).pluck(:wing)
				ll = l[0]
				m = Desk.where(id: desk_id).pluck(:section)
				mm = m[0]
				n = Desk.where(id: desk_id).pluck(:number)
				nn = n[0]
				return ll.to_s + mm.to_s + nn.to_s
			end
		end
	end

	def self.desk_schedule
		Booking.all.each do |i|
			if i.user_id == current_user.id
				a = i.book_from
				b = i.book_to
				c = i.desk_id
			end
		end
	end

	
	def self.active_bookings
		counter = 0
		Booking.all.each do |b|
			if b.user_id == current_user.id
				counter = counter + 1
			end
		end
		return counter
	end
	
	def self.nature_of_job
		return current_user.nature_of_job
	end

	# def duration(book_from, book_to)
	# 	start_date = Date.parse(book_from)
	# 	end_date = Date.parse(book_to)
	# 	duration = (end_date - start_date).to_i
	# 	return duration
	# end

	def available_desks(book_from, book_to)
		start_date = Date.parse(book_from)
		end_date = Date.parse(book_to)

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
			if (start_date - booked_end_date)*(booked_start_date - end_date) <=0
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

		p = desk.length
		(0..(p-1)).each do |i|
		desk_name = desk[i]
		desk.push(desk_name)
		end
		puts desk
	end
end
