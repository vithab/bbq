class Event < ApplicationRecord
  belongs_to :user

  has_many :comments
  has_many :subscriptions

  # У события много подписчиков (объекты User), через таблицу subscriptions,
  # по ключу user_id
  has_many :subscribers, through: :subscriptions, source: :user

  validates :user, presence: true
  validates :title, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :datetime, presence: true
end
