class CreateDesks < ActiveRecord::Migration[5.0]
  def change
    create_table :desks do |t|
      t.string :desk_type
      t.string :status
      t.string :wing
      t.string :section
      t.integer :number

      t.timestamps
    end
  end
end

