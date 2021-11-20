# frozen_string_literal: true

class User < ApplicationRecord
  validates :phone, :first_name, :last_name, presence: true

  #  валидация на уникальность и на формат
  validates :phone, uniqueness: { case_sensitive: false }

  validates :phone, format: { with: /\A7\d{10}\z/, message: 'wrong phone format' }
end
