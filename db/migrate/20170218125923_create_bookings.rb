class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.string :user_name
      t.date :book_from
      t.date :book_to

      t.timestamps
    end
  end
end
