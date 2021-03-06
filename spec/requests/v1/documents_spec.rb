require "rails_helper"

RSpec.describe "V1::Documents API", type: :request do
  let!(:user) { create(:user, role: 1) }
  let!(:user_2) { create(:user) }
  let!(:document) { create(:document, user: user) }
  let!(:document_2) { create(:document, user: user_2, access: 1) }
  let(:headers) { valid_headers(user.id) }
  let(:headers_2) { valid_headers(user_2.id) }
  let(:valid_params) { valid_document_params }

  describe "POST /documents" do
    context "when valid params" do
      before { post "/documents", params: valid_params.to_json, headers: headers }

      it "creates a new document" do
        expect(json[:message]).to eq "Document created successfully"
        expect(json[:document][:title]).to eq valid_params[:title]
        expect(json[:document][:access]).to eq "general"
        expect(json[:document][:content]).to eq valid_params[:content]
        expect(response).to have_http_status(201)
      end
    end

    context "when invalid params" do
      context "when title is empty" do
        before do
          post "/documents", params: invalid_document_params_1.to_json,
                             headers: headers
        end

        it "returns an error" do
          expect(response).to have_http_status(422)
          expect(json[:message]).to eq "Validation failed: Title can't be blank"
        end
      end

      context "when content is empty" do
        before do
          post "/documents", params: invalid_document_params_2.to_json,
                             headers: headers
        end

        it "returns an error" do
          expect(response).to have_http_status(422)
          expect(json[:message]).to eq "Validation failed: Content can't be blank"
        end
      end

      context "when access is empty" do
        before do
          post "/documents", params: invalid_document_params_3.to_json,
                             headers: headers
        end

        it "returns an error" do
          expect(response).to have_http_status(422)
          expect(json[:message]).to eq "Validation failed: Access can't be blank"
        end
      end

      context "when that user already has a document with same title" do
        before do
          Document.create(valid_params.merge(user_id: user.id))
          duplicate_title_params = duplicate_document_params

          post "/documents",
               params: duplicate_title_params.to_json, headers: headers
        end

        it "returns an error" do
          expect(json[:message]).to eq "Validation failed: Title has already been taken"
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe "GET /documents" do
    context "when admin user" do
      before { get "/documents", headers: headers }

      it "returns the user's documents and other user's public documents" do
        expect(json[:documents].first[:title]).to eq document[:title]
        expect(json[:documents].first[:access]).to eq document[:access]
        expect(json[:documents].first[:title]).to eq document[:title]
        expect(response).to have_http_status(200)
      end
    end

    context "when regular user" do
      before { get "/documents", headers: headers_2 }

      it "returns an error" do
        expect(json[:message]).to eq "Oops... you must be an admin to perform this action"
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "GET /my_documents" do
    context "when a user has documents" do
      before { get "/my_documents", headers: headers_2 }

      it "returns all user's documents" do
        expect(json[:documents].first[:title]).to eq document_2[:title]
        expect(json[:documents].first[:access]).to eq document_2[:access]
        expect(json[:documents].first[:content]).to eq document_2[:content]
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PUT /documents/:id" do
    context "when updating another user's documents" do
      before do
        put "/documents/#{document.id}",
            params: { title: "randooommmm" }.to_json, headers: headers_2
      end

      it "returns an error message" do
        expect(json[:message]).to eq "Sorry, you are not authorized to perform this action"
        expect(response).to have_http_status(403)
      end
    end

    context "when valid params" do
      before do
        put "/documents/#{document.id}",
            params: { title: "randooommmm" }.to_json, headers: headers
      end

      it "updates the document" do
        expect(document.reload.title).to eq "randooommmm"
        expect(json[:message]).to eq "Document updated successfully"
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      context "when document does not exist" do
        before do
          put "/documents/#{13}",
              params: { title: "randooommmm" }.to_json, headers: headers
        end

        it "returns an error" do
          expect(response).to have_http_status(404)
          expect(json[:message]).to eq "Couldn't find Document with 'id'=13"
        end
      end
    end
  end

  describe "DELETE /documents/:id" do
    context "when valid params" do
      before { delete "/documents/#{document.id}", headers: headers }

      it "deletes the document" do
        expect(json[:message]).to eq "Document deleted successfully"
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      context "when document does not exist" do
        before { delete "/documents/#{20}", headers: headers }

        it "returns an error" do
          expect(response).to have_http_status(404)
          expect(json[:message]).to eq "Couldn't find Document with 'id'=20"
        end
      end

      context "when the document belongs to another user" do
        before { delete "/documents/#{document_2.id}", headers: headers }

        it "returns an error" do
          expect(response).to have_http_status(403)
          expect(json[:message]).to eq "Sorry, you are not authorized to perform this action"
        end
      end
    end
  end
end
