class CreateSelections < ActiveRecord::Migration[5.0]
  def change
    create_table :selections do |t|
      t.string :selected_desk

      t.timestamps
    end
  end
end
