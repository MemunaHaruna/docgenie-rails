require "rails_helper"

RSpec.describe Document, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:access) }

  it { should validate_uniqueness_of(:title).scoped_to(:user_id) }
  it { should belong_to(:user) }
end
