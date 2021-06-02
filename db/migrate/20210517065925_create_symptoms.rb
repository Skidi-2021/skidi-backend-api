class CreateSymptoms < ActiveRecord::Migration[6.1]
  def change
    create_table :symptoms do |t|
      t.string   :symptom_name
      t.string   :author
      
      # GeoLocation for Medical Purpose
      t.float    :latitude
      t.float    :longitude

      t.belongs_to :user

      t.timestamps
    end
  end
end
