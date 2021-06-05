class SymptomSerializer
  include JSONAPI::Serializer
  include Helpers::SymptomHelper
  
  belongs_to :user

  attributes :symptom_name, :author, :created_at
  attribute :url do |symptom|
    symptom_url(symptom)
  end
  
end
