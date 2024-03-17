3.times { FactoryBot.create(:user) }
10.times { FactoryBot.create(:video, :skip_callbacks, user: User.order('RANDOM()').first) }
