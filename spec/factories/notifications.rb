FactoryBot.define do
  factory :notification do
    user { nil }
    actor { nil }
    notifiable { nil }
    action { "MyString" }
    read_at { "2025-09-06 04:10:19" }
    data { "" }
  end
end
