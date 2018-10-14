class V1::DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :update, :destroy]

  def index
    doc = Document.where(access: 0).or(Document.where(user_id: current_user.id))
    doc = doc.page(params[:page]).per(5)
    json_response(status: :ok, object: doc)
  end

  def create
    doc = current_user.documents.create!(document_params)
    json_response(status: :created, object: doc, message: Message.document_created)
  end

  def show
    if @document.personal? && @document.user_id != current_user.id
      raise ExceptionHandler::UnauthorizedUser, Message.access_not_granted
    else
      json_response(status: :ok, object: @document)
    end
  end

  def update
    document = current_user.documents.find(@document.id)
    document.update(document_params)
    json_response(status: :ok, object: @document.reload, message: Message.document_updated)
  end

  def destroy
    verify_user_has_correct_requirements(@document)

    @document.destroy!
    json_response_default(status: :ok, message: Message.document_deleted)
  end

  private

    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.permit(:title, :access, :content)
    end
end
