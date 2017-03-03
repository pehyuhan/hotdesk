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
			if current_date <= booked_end_date && booked_start_date <= current_date
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
		desk_schedule = []
		Booking.all.each do |i|
			if i.user_id == current_user.id
				booked = []
				book_from = i.book_from
				booked.push(book_from)
				book_to = i.book_to
				booked.push(book_to)
				desk_id = i.desk_id
				l = Desk.where(id: desk_id).pluck(:wing)
				ll = l[0]
				m = Desk.where(id: desk_id).pluck(:section)
				mm = m[0]
				n = Desk.where(id: desk_id).pluck(:number)
				nn = n[0]
				desk_name = ll.to_s + mm.to_s + nn.to_s
				booked.push(desk_name)
				desk_schedule.push(booked)
			end
		end
		return desk_schedule
	end

	# def self.check_availability(args)
	# 	args = [book_from, book_to]
	# 	self.book_from = start_date
	# 	self.book_to = end_date
	# 	desk = []

	# 	Desk.all.each do |e|
	# 	f = e.wing
	# 	g = e.section
	# 	h = e.number
	# 	j = f.to_s + g.to_s + h.to_s
	# 	desk.push(j)
	# 	end

	# 	Booking.all.each do |k|
	# 		booked_start_date = k.book_from
	# 		booked_end_date = k.book_to
	# 		desk_id = k.desk_id
	# 		if (start_date - booked_end_date)*(booked_start_date - end_date) <=0
	# 			l = Desk.where(id: desk_id).pluck(:wing)
	# 			ll = l[0]
	# 			m = Desk.where(id: desk_id).pluck(:section)
	# 			mm = m[0]
	# 			n = Desk.where(id: desk_id).pluck(:number)
	# 			nn = n[0]
	# 			o = ll.to_s + mm.to_s + nn.to_s
	# 			desk.delete(o)
	# 		end
	# 	end
	# 	return desk
	# 	redirect_back(fallback_location: book_user_bookings_path)
	# end
end