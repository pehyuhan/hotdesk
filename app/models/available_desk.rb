class AvailableDesk < ApplicationRecord
	belongs_to :bookings, optional: true
end
