class VideoSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :id, :title, :url
  attribute :description do |video, params|
    des = video.description
    !params[:is_truncated] || des.nil? ? des : des.truncate_words(Settings[:videos][:description][:max_words])
  end

  belongs_to :user
end
