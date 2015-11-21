class Post < ActiveRecord::Base
  belongs_to :sub

  belongs_to :author,
    class_name: "User"

  validates :title, :sub_id, :author_id, presence: true 
end
