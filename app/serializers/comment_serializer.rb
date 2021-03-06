# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body

  belongs_to :user
  belongs_to :document
end
