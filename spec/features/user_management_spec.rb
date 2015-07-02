feature 'User sign up' do


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
    expect { sign_up( password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario "user can't sign up without entering an email address" do
    expect { sign_up( email: '') }.not_to change( User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email must not be blank'
  end


  def sign_up(email: 'alice@example.com',
              password: 'password',
              password_confirmation: 'password')
    visit '/users/new'
    fill_in :email,    with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end
end