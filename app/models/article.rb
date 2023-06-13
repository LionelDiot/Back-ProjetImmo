class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :isPrivate, inclusion: { in: [true, false] }
  belongs_to :user
end
