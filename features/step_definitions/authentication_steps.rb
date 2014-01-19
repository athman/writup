Given(/^a user visits the signin page$/) do
  visit signin_path
end

When(/^they submit invalid signin information$/) do
  click_button "Sign in"
end

Then(/^they should see an error message$/) do
  expect(page).to have_selector("div.alert.alert-danger")
end

Given(/^the user has an account$/) do
  @user = FactoryGirl.create(:user)
end

When(/^the user submts valid signin information$/) do
  fill_in "session_email",       with: @user.email
  fill_in "session_password",    with: @user.password
  click_button "Sign in"
end

Then(/^they should see their profile page$/) do
  expect(page).to have_title(@user.first_name)
end

Then(/^they should see a signout link$/) do
  expect(page).to have_link("Sign out", href: signout_path)
end
