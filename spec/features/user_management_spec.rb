feature 'User sign up' do

  let!(:user) { build :user }

  scenario 'users/new page loads correctly' do
    visit '/users/new'
    expect(page.status_code).to eq(200)
  end

  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario "user can't sign up without entering an email address" do
    expect { sign_up( email: '') }.not_to change( User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect { sign_up }.not_to change(User, :count)
    expect(page).to have_content('Email is already taken')
  end

  # def sign_up(email: user.email,
  #             password: user.password,
  #             password_confirmation: user.password_confirmation)
  #   visit '/users/new'
  #   fill_in :email,    with: email
  #   fill_in :password, with: password
  #   fill_in :password_confirmation, with: password_confirmation
  #   click_button 'Sign up'
  # end

end

feature 'User sign in' do

  scenario 'with correct credentials' do
    user = create :user
    sign_in(user.email, user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end

  # def sign_in(email, password)
  #   visit '/sessions/new'
  #   fill_in :email, with: email
  #   fill_in :password, with: password
  #   click_button 'Sign in'
  # end

end

feature 'User signs out' do

  scenario 'while being signed in' do
    user = create :user
    sign_in(user.email, user.password)
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, #{user.email}')
  end

end


feature 'Password reset' do

  scenario 'requesting a password reset' do
    user = create :user
    visit '/password_reset'
    fill_in 'email', with: user.email
    click_button 'Reset password'
    user = User.first(email: user.email)
    expect(user.password_token).not_to be_nil
    expect(page).to have_content 'Check your emails'
  end

  scenario 'resetting password' do
    user = create :user
    user.password_token = 'token'
    user.save

    visit "/users/password_reset/#{user.password_token}"
    expect(page.status_code).to eq 200
    expect(page).to have_content 'Enter a new password'
  end

end










