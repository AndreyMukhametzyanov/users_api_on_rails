FactoryBot.define do
  factory :user do
    sequence(:phone) { |i| 70000000000 + i }
    first_name { "MyString" }
    last_name { "MyString" }
    date_of_birth { "2021-11-06 17:32:38" }
    comment { "my_comment" }
  end
end
