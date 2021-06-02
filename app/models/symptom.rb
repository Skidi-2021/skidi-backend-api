class Symptom < ApplicationRecord
    has_one_attached :image
    belongs_to :user
    validates :symptom_name, presence: true
end
