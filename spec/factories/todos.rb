FactoryBot.define do
  factory :todo do
    title { "MyString" }
    description { "MyText" }
    deadline { "2025-01-05" }
    status { false }
  end
end
