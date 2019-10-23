require 'rails_helper'

describe 'User show page' do
  before :each do
    @user = create(:user)
    @user2 = create(:user)
    @review = create(:review, user: @user, reviewer: @user2, rating: 5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_2)

    visit "/users/#{@user.username}"
  end
  it 'shows info about that user' do

    expect(page).to have_content("#{@user.username}'s Profile")
    expect(page).to have_content('Average Rating: 5')
    expect(page).to have_css('.reviews')

    within(first('.reviews')) do
      expect(page).to have_content(@user2.username)
      expect(page).to have_content(@review.rating)
      expect(page).to have_content(@review.content)
    end
  end

  it 'Users can leave reviews about that user' do
    expect(page).to have_css('.new-review')

    within('.new-review') do
      select 3, from: :rating
      fill_in :content, with: 'This guy rocks!'
      click_on 'Submit'
    end

    within(first('.reviews')) do
      expect(page).to have_content(@user2.username)
      expect(page).to have_content(3)
      expect(page).to have_content('This guy rocks!')
    end

    expect(page).to have_content('Average Rating: 4')
  end
end
