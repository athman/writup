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
  
end
