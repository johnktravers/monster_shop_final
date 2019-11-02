require 'rails_helper'

RSpec.describe "As a visitor" do
  it "cannot access certain paths" do
    visit '/merchant'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/admin'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    visit '/profile'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
