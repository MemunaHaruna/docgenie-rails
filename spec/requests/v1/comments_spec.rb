require "rails_helper"

RSpec.describe "V1::Comments API", type: :request do
  let!(:user) { create(:user, role: 1) }
  let!(:user_2) { create(:user) }
  let(:document) { create(:document, user: user) }
  let(:comment) { create(:comment, user: user, document: document) }
  let(:comment_2) { create(:comment, user: user_2, document: document) }
  let(:headers) { valid_headers(user.id) }
  let(:headers_2) { valid_headers(user_2.id) }

  describe "POST /documents/:document_id/comments" do
    context "when valid params" do
      before { post "/documents/#{document.id}/comments",
                    params: { body: 'testing'}.to_json,
                    headers: headers
              }

      it "creates a new comment" do
        expect(json[:comment][:body]).to eq "testing"
        expect(json[:comment][:user][:id]).to eq user.id
        expect(json[:comment][:document][:id]).to eq document.id
        expect(response).to have_http_status(201)
      end
    end

    context "when invalid params" do
      context "when body is empty" do
        before do
          post "/documents/#{document.id}/comments",
                params: { body: ''}.to_json,
                headers: headers
        end

        it "returns an error" do
          expect(response).to have_http_status(422)
          expect(json[:message]).to eq "Validation failed: Body can't be blank"
        end
      end
    end
  end

  describe "DELETE /documents/:document_id/comments/:id" do
    context "when the comment exists" do
      before { delete "/documents/#{document.id}/comments/#{comment.id}",
                headers: headers }

      it "deletes the comment" do
        expect(json[:message]).to eq "Comment deleted successfully"
        expect(response).to have_http_status(200)
      end
    end

    context "when the comment does not exist" do
      before { delete "/documents/#{document.id}/comments/#{15}",
                headers: headers }

      it "deletes the comment" do
        expect(json[:message]).to include "Couldn't find Comment with 'id'=15"
        expect(response).to have_http_status(404)
      end
    end

    context "when the document belongs to another user" do
      before { delete "/documents/#{document.id}/comments/#{comment.id}",
                headers: headers_2 }

      it "returns an error" do
        expect(response).to have_http_status(403)
        expect(json[:message]).to eq "Sorry, you are not authorized to perform this action"
      end
    end
  end
end
