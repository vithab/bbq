class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true

  # проверки выполняются только если user не задан (незареганные приглашенные)
  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/, unless: -> { user.present? }

  validates :user, uniqueness: { scope: :event_id, message: I18n.t('subscription.already_subscribed') }, if: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }

  validate :user_not_organizer, on: :create, if: -> { user.present? }
  validate :user_email_uniq, on: :create, unless: -> { user.present? }

  def user_not_organizer
    errors.add(:user_id, I18n.t('errors.organizer_subscribe')) if user == event.user
  end

  def user_email_uniq
    errors.add(:user_email, I18n.t('errors.user_email')) if User.all.where(email: user_email).any?
  end

  # переопределяем метод, если есть юзер, выдаем его имя,
  # если нет -- дергаем исходный переопределенный метод
  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  # переопределяем метод, если есть юзер, выдаем его email,
  # если нет -- дергаем исходный переопределенный метод
  def user_email
    if user.present?
      user.email
    else
      super
    end
  end
end
