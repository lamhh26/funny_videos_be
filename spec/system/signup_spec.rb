require 'rails_helper'

RSpec.describe 'Signup', type: :system do
  before do
    allow_any_instance_of(ApplicationController).to receive(:protect_against_forgery?).and_return(false)
  end

  describe 'in signup modal' do
    before do
      visit '/'
      click_button 'Signup'
    end

    context 'fill in with invalid values' do
      it 'submits with empty fields' do
        within(:xpath, '//form') do |form|
          click_button 'Signup'
          expect(form).to have_xpath('./p[1]', text: "Email can't be blank")
          expect(form).to have_xpath('./p[2]', text: "Password can't be blank")
        end
      end

      it 'submits with an invalid email' do
        within(:xpath, '//form') do |form|
          fill_in 'Email', with: 'a'
          click_button 'Signup'
          expect(form).to have_xpath('./p[1]', text: 'Email is invalid')
        end
      end

      it 'submits with a taken email' do
        create(:user, email: 'a@example.com')
        within(:xpath, '//form') do |form|
          fill_in 'Email', with: 'a@example.com'
          click_button 'Signup'
          expect(form).to have_xpath('./p[1]', text: 'Email has already been taken')
        end
      end

      it 'submits with an invalid password' do
        within(:xpath, '//form') do |form|
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'a'
          click_button 'Signup'
          expect(form).to have_xpath('./p[1]', text: 'Password is too short (minimum is 6 characters)')
        end
      end

      it 'submits with an unmached password confirmation' do
        within(:xpath, '//form') do |form|
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'Abcd1234'
          fill_in 'Password confirmation', with: 'Abcd1235'
          click_button 'Signup'
          expect(form).to have_xpath('./p[1]', text: "Password confirmation doesn't match Password")
        end
      end
    end

    context 'fill in with valid values' do
      it 'submits successfully' do
        within(:xpath, '//form') do
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'Abcd1234'
          fill_in 'Password confirmation', with: 'Abcd1234'
          click_button 'Signup'
        end

        expect(page).to have_xpath("//div[@class='topnav']//span", text: 'Welcome a@example.com')
      end
    end
  end
end
