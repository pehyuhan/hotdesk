class CreateAvailableDesks < ActiveRecord::Migration[5.0]
  def change
    create_table :available_desks do |t|
      t.string :desk_name

      t.timestamps
    end
  end
end
