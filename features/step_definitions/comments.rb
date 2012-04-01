# encoding: utf-8
When /^I add comment:(.*)$/ do |comment|
  fill_in "comment[content]", :with => comment
  click_button '发送'
end
