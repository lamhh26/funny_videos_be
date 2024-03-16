require 'rails_helper'

RSpec.describe 'Videos', type: :system do
  describe 'index page' do
    let(:user) { create(:user) }

    context 'there are videos' do
      let!(:videos) do
        [
          create(:video, :skip_callbacks, user:, description: FFaker::Lorem.paragraph(50)),
          create(:video, :skip_callbacks, user:, description: FFaker::Lorem.paragraph(50))
        ]
      end

      before do
        visit('/')
      end

      it 'shows the right content' do
        expect(page).to have_xpath("//div[@class='topnav']//following-sibling::*/div/div", count: videos.size)
        videos.reverse.each_with_index do |video, index|
          expect(page).to have_xpath("(//div[p[text()='Shared by']]//p[2])[#{index + 1}]", text: video.user.email)
          expect(page).to have_xpath("(//div[p[text()='Description']]//p[2])[#{index + 1}]",
                                     text: video.description.truncate_words(100))
        end
      end
    end

    context 'when a error occurs ' do
      it 'displays a error message' do
        allow(Video).to receive(:latest).and_raise Errors::StandardError

        visit('/')

        expect(page).to have_content 'We encountered unexpected error'
      end
    end
  end
end
