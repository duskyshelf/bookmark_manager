describe User do

  let!(:user) do
    User.create(email: 'test@test.com', password: 'secret1234', password_confirmation: 'secret1234')
  end

  it 'authenticates when given a valid email and password' do
    authenticated_user = User.authenticate(email: user.email, password: user.password)
    expect(authenticated_user).to eq user
  end

  it 'does not authenticate when given an incorrect password' do
    authenticated_user = User.authenticate(email: user.email, password: 'wrong_password')
    expect(authenticated_user).to be_nil
  end

end