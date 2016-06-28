feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, test@test.com')
    expect(User.first.email).to eq('test@test.com')
  end

  scenario 'requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'I cannot sign up with an existing email' do
    sign_up
    expect { sign_up }.to_not change(User, :count)
    expect(page).to have_content('Email is already taken')
  end

  scenario 'I cannot sign up withOUT an email address' do
    expect { sign_up(email: nil) }.to_not change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email must not be blank')
  end

  scenario 'I cannot sign up with an invalid email address' do
    expect { sign_up(email: 'invalid@email') }.to_not change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Email has an invalid format')
  end

  scenario 'I cannot sign up with a blank password' do
    expect { sign_up(password: '', password_confirmation: '') }.to_not change(User, :count)
  end

  scenario 'I want the login link to take me to the login page' do
    visit('/users/new')
    click_link('Log in')
    expect(current_path).to eq('/sessions/new')
    expect(page).to have_content('Log in to MakersBnB')
  end

  scenario 'Logs in user and takes them to the spaces page' do
    User.create(email: 'sdawes@gmail.com', password: 'password', password_confirmation: 'password')
    visit('sessions/new')
    


    fill_in(:email, with: 'sdawes@gmail.com')
    fill_in(:password, with: 'password')
    click_button('Log in')
    expect(current_path).to eq('/spaces')
    expect(page).to have_content('Welcome to MakersBnB')
  end
end







