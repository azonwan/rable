Then /^it should display a logout icon$/ do
  page.should have_css("img.eject")
end

When /^I click the logout icon$/ do
  find("img.eject").find(:xpath, '..').click
end

Then /^it should display a settings icon$/ do
  page.should have_css("img.gear")
end

Then /^it should display the version number$/ do
  steps %Q(Then I should see #{Rabel.version})
end
