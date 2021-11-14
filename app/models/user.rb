class User < ApplicationRecord
  validates :phone, :first_name, :last_name, presence: true

  #  валидация на уникальность и на формат
  validates :phone, uniqueness: true
  validates :phone, format: { with: /\A7\d{10}\z/, message: 'wrong phone format' }
end
