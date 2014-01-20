include ApplicationHelper

# A helper for page titles
def full_title page_title
  base_title = "Writup"
  if page_title.empty?
    base_title
  else
    "#{base_title}::#{page_title}"
  end
end

def valid_signin user
  fill_in "session_email",        with: user.email
  fill_in "session_password",     with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector("div.alert.alert_danger")
  end
end