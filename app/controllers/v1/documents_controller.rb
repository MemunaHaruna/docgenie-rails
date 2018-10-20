# frozen_string_literal: true

module V1
  class DocumentsController < ApplicationController
    before_action :set_document, only: %i[show update destroy]

    def index
      require_admin
      doc = Document.where(access: 0).or(
        Document.where(user_id: current_user.id)
      )
      doc = doc.page(params[:page]).per(params[:per_page] || 5)
      json_response(status: :ok, object: doc)
    end

    def my_documents
      docs = current_user.documents
      docs = docs.page(params[:page]).per(params[:per_page] || 5)
      json_response(status: :ok, object: docs)
    end

    def create
      doc = current_user.documents.create!(document_params)
      json_response(
        status: :created,
        object: doc,
        message: Message.document_created
      )
    end

    def show
      if @document.personal?
        raise_error_if_not_current_user(@document.user)
      end
      json_response(status: :ok, object: @document)
    end

    def update
      raise_error_if_not_current_user(@document.user)
      document = current_user.documents.find(@document.id)
      document.update(document_params)
      json_response(
        status: :ok,
        object: @document.reload,
        message: Message.document_updated
      )
    end

    def destroy
      raise_error_if_not_current_user(@document.user)
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
end
