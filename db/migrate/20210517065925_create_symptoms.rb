class CreateSymptoms < ActiveRecord::Migration[6.1]
  def change
    create_table :symptoms do |t|
      t.string :name
      t.string :author

      t.timestamps
    end
  end
end
