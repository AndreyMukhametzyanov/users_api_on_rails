class User < ApplicationRecord
  validates :phone, :first_name, :last_name, presence: true
end
