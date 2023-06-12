class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :private, inclusion: { in: [true, false] }
  belongs_to :user
end
