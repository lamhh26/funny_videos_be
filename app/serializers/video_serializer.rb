class VideoSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :id, :title, :description, :url
end
