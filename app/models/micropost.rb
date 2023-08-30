class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  scope :relate_post, ->(user_ids) {where user_id: user_ids}
  validates :content, presence: true,
            length: {maximum: Settings.micro_post.content.length.max}
  validates :image, content_type: {in: Settings.micro_post.image.type,
                                   message: I18n.t("micro_post.message_type")},
                  size: {less_than: Settings.micro_post.image.size_5.megabytes,
                         message: I18n.t("micro_post.message_size")}

  delegate :name, to: :user, prefix: true, allow_nil: true
  def display_image
    image.variant resize_to_limit: [500, 500]
  end

end
