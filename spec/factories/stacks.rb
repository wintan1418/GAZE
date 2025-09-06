FactoryBot.define do
  factory :stack do
    name { "MyString" }
    description { "MyText" }
    user { nil }
    visibility { 1 }
    color { "MyString" }
  end
end
