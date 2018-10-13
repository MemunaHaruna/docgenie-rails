class DocumentsController < ApplicationController
  before_action :set_document, only: [:update, :destroy]

  def index
    doc = Document.all.where(access: 0).or(Document.where(user_id: current_user.id))
    json_response(status: :ok, object: {documents: doc})
  end

  def create
    doc = current_user.documents.create!(document_params)
    json_response(status: :created, object: {document: doc}, message: Message.document_created)
  end

  def update
    document = current_user.documents.find(@document.id)
    document.update(document_params)
    json_response(status: :ok, object: { document: @document.reload }, message: Message.document_updated)
  end

  def destroy
    verify_user_has_correct_requirements(@document)

    @document.destroy!
    json_response(status: :ok, message: Message.document_deleted)
  end

  private

    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.permit(:title, :access, :content)
    end
end
