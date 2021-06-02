class UserSerializer
  include JSONAPI::Serializer
  attributes :full_name, :birthday, :gender, :email
end
