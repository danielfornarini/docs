# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def ability
      @ability ||= Ability.new(current_user)
    end

    private

    def find_verified_user
      token = request.params[:token]

      payload = CognitoRails::JWT.decode(token)

      auth_id = payload&.dig(0, 'sub')

      return reject_unauthorized_connection if auth_id.blank?

      User.find_by(auth_id:) || reject_unauthorized_connection
    end

    # def decode_jwt(token)
    #   CognitoRails::JWT.decode(token)
    #   region = 'eu-central-1'
    #   pool_id = 'eu-central-1_t1i24ScEg'

    #   aws_idp = Rails.cache.fetch('aws_idp', expires_in: 4.hours) do
    #     URI.open("https://cognito-idp.#{region}.amazonaws.com/#{pool_id}/.well-known/jwks.json").read
    #   end

    #   jwt_config = JSON.parse(aws_idp, symbolize_names: true)

    #   JWT.decode(token, nil, true, { jwks: jwt_config, algorithms: ['RS256'] })
    # rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    #   {}
    # end
  end
end
