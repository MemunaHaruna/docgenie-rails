class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role

  has_many :documents, if: -> { should_render_association }

  def should_render_association
    @instance_options[:show_children]
  end
end
