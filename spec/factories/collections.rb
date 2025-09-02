FactoryBot.define do
  factory :collection do
    name { "MyString" }
    description { "MyText" }
    visibility { 1 }
    user { nil }
    slug { "MyString" }
  end
end
