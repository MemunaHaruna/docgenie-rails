FactoryBot.define do
  factory :comment do
    body "test comment"
    user
    document
  end
end
