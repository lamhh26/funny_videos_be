class CommentSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :content

  belongs_to :video
  belongs_to :user
end
