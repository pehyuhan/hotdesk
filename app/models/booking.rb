class Booking < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :desk, optional: true
	accepts_nested_attributes_for :desk, allow_destroy: true
end
