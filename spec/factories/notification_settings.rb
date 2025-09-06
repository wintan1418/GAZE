FactoryBot.define do
  factory :notification_setting do
    user { nil }
    email_comments { false }
    email_stars { false }
    email_views { false }
    email_copies { false }
    push_comments { false }
    push_stars { false }
    push_views { false }
    push_copies { false }
  end
end
