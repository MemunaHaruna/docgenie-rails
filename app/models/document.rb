# frozen_string_literal: true

class Document < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :access, :user_id, :content
  validates_uniqueness_of :title, scope: :user_id

  enum access: %w[general personal]
end
