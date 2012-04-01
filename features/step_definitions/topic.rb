# encoding: utf-8

Then /^it should display a topic creation form$/ do
  page.should have_css('form.new_topic')
  page.should have_no_css('input.sll')
  page.should have_css('textarea.mll')
end

Then /^it should display a topic edit form$/ do
  page.should have_css('form.edit_topic')
  page.should have_no_css('input.sll')
  page.should have_css('textarea.mll')
end

Then /^it should display a comment form$/ do
  page.should have_css('form.new_comment')
  page.should have_content('现在就添加一条回复')
end

Then /^it should not display a comment form$/ do
  page.should have_no_css('form.new_comment')
  page.should have_no_content('现在就添加一条回复')
end

Given /^the topic has comments of (\d+) pages?$/ do |pages|
  topic = Topic.first
  (Settings.pagination.comments_per_topic * pages.to_i).times do
    Factory(:comment, :commentable => topic)
  end
end

Then /^it should display the nagination links$/ do
  within(".pagination") do
    page.should have_css('.page_normal')
    page.should have_css('.page_current')
  end
end

Then /^the current page is the last page$/ do
  last_child = find(".pagination :last-child")
  last_child.tag_name.should == 'span'
  last_child[:class].should == 'page_current'
end

def str_to_num(str)
   case str
     when 'first'
       1
     when 'second'
       2
     when 'third'
       3
     end
end

When /^I click the (.*) page$/ do |page|
  within(".pagination") do
    click_link str_to_num(page).to_s
  end
end

Then /^the current page should be the (.*) page$/ do |page|
  find(".pagination .page_current").text.should == str_to_num(page).to_s
end

Given /^a node exists with custom html: (.*)$/ do |html|
  Factory(:node, :custom_html => html)
end

Then /^it should display custom widget: (.*)$/ do |content|
  within("#Rightbar") do
    page.should have_content(content)
  end
end

Then /^it should display a mention button$/ do
  page.should have_css('img.mention_button')
end

When /^I click the mention button$/ do
  find("img.mention_button:first").click
end

Then /^the commenter user name should appear in the comment box$/ do
  mention_button = find("img.mention_button:first")
  find("#comment_content").value.should have_content(mention_button['data-mention'])
end

Then /^it should not display any mention buttons$/ do
  page.should have_no_css("img.mention_button")
end
