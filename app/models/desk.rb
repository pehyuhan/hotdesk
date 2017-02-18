class Desk < ApplicationRecord
	validates :desk_type, :status, :wing, :section, :number, presence: true

end
