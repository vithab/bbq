class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :events
  has_many :comments
  has_many :subscriptions

  validates :name, presence: true, length: {maximum: 35}

  # при создании нового юзера (create), перед валидацией объекта выполнить метод set_name
  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  private

  # задаем юзеру случайное имя, если оно пустое
  def set_name
    self.name = "Гость №#{rand(999)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
        .update_all(user_id: self.id)
  end
end
