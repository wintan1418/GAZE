FactoryBot.define do
  factory :edit_request do
    snippet { nil }
    requester { nil }
    approver { nil }
    status { "MyString" }
    message { "MyText" }
  end
end
