# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  content    :text
#

class Post < ActiveRecord::Base
  
  belongs_to :user
  default_scope -> { order("created_at DESC") }
  validates :content, presence: true, length: { minimum: 100 }
  validates :user_id, presence: true
  
  def self.from_users_followed_by(user)
    #followed_user_ids = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  end
  
end
