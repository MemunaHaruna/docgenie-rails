module V1
  class CommentsController < ApplicationController
    before_action :set_document
    before_action :set_comment, only: :destroy

    def create
      comment = Comment.create!(comment_create_params)

      json_response(
        status: :created,
        object: comment,
        message: Message.comment_created
      )
    end

    def destroy
      raise_error_if_not_current_user(@comment.user)
      @comment.destroy!
      json_response_default(status: :ok, message: Message.comment_deleted)
    end

    private

    def set_document
      @document ||= Document.find(params[:document_id])
    end

    def set_comment
      @comment ||= @document.comments.find(params[:id])
    end

    def comment_params
      params.permit(:body)
    end

    def comment_create_params
      comment_params.merge(document_id: @document.id, user_id: current_user.id)
    end
  end
end
