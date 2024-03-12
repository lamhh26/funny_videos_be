# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    raise Errors::InvalidRecord, resource.errors.to_hash unless resource.persisted?

    render json: {
      status: { code: 200, message: 'Signed up successfully.' },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }
  end
end
