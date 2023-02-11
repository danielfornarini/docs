module UserAuthenticationContext
  def with_authenticated_user(&block)
    context 'with user' do
      let!(:user) do
        user = create(:user)
        user.confirm
        sign_in user
        user
      end

      instance_exec(&block)
    end
  end
end
