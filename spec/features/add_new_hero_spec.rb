require 'rails_helper'

feature 'user adds a new hero' do
  before :each do
    visit root_path

    expect(page).to have_content("Hero")
    expect(page).to have_content("Number of Comics")
    expect(page).to have_content("Number of Series")
    expect(page).to have_content("Number of Stories")
    expect(page).to have_content("Number of Events")
  end

  scenario 'user adds new hero successfully' do
    fill_in 'Enter Hero Name', with: 'Captain America'
    click_on 'Add Hero'

    expect(page).to have_content("Captain America has been added!")
    expect(page).to have_content("1445")
    expect(page).to have_content("395")
    expect(page).to have_content("2360")
    expect(page).to have_content("19")
  end

  scenario 'user adds a new hero incorrectly' do
    fill_in 'Enter Hero Name', with: 'Captain China'
    click_on 'Add Hero'

    expect(page).to have_content("I'm unable to find this hero :( Maybe check if you've entered the name correctly?")
  end

  scenario 'user adds an existing hero' do
    fill_in 'Enter Hero Name', with: 'Captain America'
    click_on 'Add Hero'

    fill_in 'Enter Hero Name', with: 'Captain America'
    click_on 'Add Hero'

    expect(page).to have_content("This hero has already been added to the list!")
  end

  scenario 'user can view common events between heroes' do
    fill_in 'Enter Hero Name', with: 'Captain America'
    click_on 'Add Hero'
    click_on 'Captain America'

    expect(page).to have_content("afasd")
  end
end
