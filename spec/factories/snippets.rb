FactoryBot.define do
  factory :snippet do
    user { nil }
    title { "MyString" }
    description { "MyText" }
    code { "MyText" }
    language { "MyString" }
    visibility { 1 }
    slug { "MyString" }
  end
end
