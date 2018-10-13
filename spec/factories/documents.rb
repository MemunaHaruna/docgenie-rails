FactoryBot.define do
  factory :document do
    title "test title"
    access 0
    content "test content"
    user
  end
end
