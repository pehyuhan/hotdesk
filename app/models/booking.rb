class Booking < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :desk, optional: true
	accepts_nested_attributes_for :desk, allow_destroy: true
	cattr_accessor :current_user
	validates :user_id, presence: true
	validates :book_from, :book_to, presence: true

	def active_bookings
		counter = 0
		Booking.all.each do |b|
			current_date = Date.today
			booked_start_date = b.book_from
			booked_end_date = b.book_to
			if b.user_id == current_user.id && current_date <= booked_end_date && booked_start_date <= current_date
				counter += 1
			end
		end
		counter
	end

	def date_range(book_from, book_to)
		duration = (book_to - book_from).to_i
		duration += 1
	end

	def available_desks(book_from, book_to)
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
		desk
	end

	def book_desk(book_from, book_to, desk_name)
		user_name = current_user.name
		user_id = current_user.id

		a = desk_name.split('')
		wing = a[0]
		section = a[1]
		number = a[2] 
		did = Desk.where(wing: wing, section: section, number: number).pluck(:id)
		desk_id = did[0]

		Booking.create(:user_name=>user_name, :user_id=>user_id, :book_from=>book_from, :book_to=>book_to, :desk_id=>desk_id)
	end





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
end