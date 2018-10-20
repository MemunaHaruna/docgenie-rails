class Comment < ApplicationRecord
  belongs_to :document
  belongs_to :user

  validates_presence_of :body, :document_id
end
