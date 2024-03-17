require 'rails_helper'

RSpec.describe 'Login', type: :system do
  before do
    allow_any_instance_of(ApplicationController).to receive(:protect_against_forgery?).and_return(false)
  end

  describe 'in login modal' do
    before do
      create(:user, email: 'a@example.com', password: 'Abcd1234')
      visit '/'
      click_button 'Login'
    end

    context 'fill in with invalid values' do
      it 'submits with empty fields' do
        within(:xpath, "//div[h1[text()='Login']]") do |form|
          click_button 'Login'
          expect(form).to have_xpath('.//p[1]', text: 'You need to sign in or sign up before continuing.')
        end
      end

      it 'submits with an invalid email' do
        within(:xpath, "//div[h1[text()='Login']]") do |form|
          fill_in 'Email', with: 'a'
          click_button 'Login'
          expect(form).to have_xpath('.//p[1]', text: 'Invalid Email or password.')
        end
      end

      it 'submits with an invalid password' do
        within(:xpath, "//div[h1[text()='Login']]") do |form|
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'Abcd1235'
          click_button 'Login'
          expect(form).to have_xpath('.//p[1]', text: 'Invalid Email or password.')
        end
      end
    end

    context 'fill in with valid values' do
      it 'submits successfully' do
        within(:xpath, "//div[h1[text()='Login']]") do
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'Abcd1234'
          click_button 'Login'
        end

        expect(page).to have_xpath("//div[@class='topnav']//span", text: 'Welcome a@example.com')
      end
    end
  end
end
