# encoding: utf-8

def path_to(page)
  case page
  when 'the home'
    root_path
  when 'the login'
    new_user_session_path
  when 'the signout'
    destroy_user_session_path
  when 'the register'
    new_user_registration_path
  when 'the settings'
    settings_path
  when /(.*)'s profile/
    nickname = $1
    if nickname == 'the user'
      user = User.first
    else
      user = User.find_by_nickname(nickname)
    end
    member_path(user.nickname)
  when 'the topic'
    topic = Topic.first
    t_path(topic.id)
  when 'the node'
    node = Node.first
    go_path(node.key)
  when 'the topic creation'
    node = Node.first
    new_node_topic_path(node)
  when 'my following'
    my_following_path
  when 'the admin pages'
    admin_pages_path
  when 'the admin users'
    admin_users_path
  when 'the admin topics'
    admin_topics_path
  when 'the admin planes'
    admin_planes_path
  when 'the admin ads'
    admin_advertisements_path
  when 'the admin page creation'
    new_admin_page_path
  when 'the admin edit page'
    page = Page.first
    edit_admin_page_path(page)
  when 'the page'
    page = Page.first
    page_path(page.key)
  when 'the goodbye'
    goodbye_path
  when 'the password reset'
    new_user_password_path
  when 'the notifications'
    notifications_path
  else
    raise 'Unknown page'
  end
end

Given /^I am on (.*) page$/ do |page|
  visit path_to(page)
end

When /^wait (\d+)s$/ do |i|
  sleep i.to_i
end

When /^debug$/ do
  debugger
end

Given /^I logout$/ do
  within('#Top') do
    click_link '登出'
  end
end

When /^I try to register$/ do
  visit new_user_registration_path
end

Given /^I am not authenticated$/ do
  steps %Q(Given I am on the home page)
  steps %Q(Then I should not see 登出)
end

Given /^an? (.*) exists with nickname: (.*)$/ do |type, nickname|
  Factory(type.to_sym, :nickname => nickname)
end

Given /^I have logged in as (.*)$/ do |nickname|
  user = User.find_by_nickname(nickname)
  steps %Q(Given an user exists with nickname: #{nickname}) unless user.present?
  visit new_user_session_path
  fill_in 'user_nickname', :with => nickname
  fill_in 'user_password', :with => Settings.default_password
  click_button '登入'
end

Then /^I should not see (.*)$/ do |text|
  page.should have_no_content(text)
end

Then /^I should see (.*)$/ do |text|
  page.should have_content(text)
end

Then /^I should be redirected to (.*) page$/ do |page|
  current_path.should == path_to(page)
end

Given /^a node exists with name: (.*)$/ do |name|
  Factory(:node, :name => name)
end

Given /^a topic exists with title:(.*)$/ do |title|
  Factory(:topic, :title => title)
end

Given /^a topic under the node exists with title:(.*)$/ do |title|
  node = Node.first
  Factory(:topic, :node => node, :title => title)
end

Given /^a topic of (.*) exists with title:(.*)$/ do |nickname, title|
  if nickname == 'the user' or nickname == 'me'
    user = User.first
  else
    user = User.find_by_nickname(nickname)
  end
  Factory(:topic, :user => user, :title => title)
end

Given /^a locked topic of (.*) exists with title:(.*)$/ do |nickname, title|
  if nickname == 'the user' or nickname == 'me'
    user = User.first
  else
    user = User.find_by_nickname(nickname)
  end
  Factory(:locked_topic, :user => user, :title => title)
end

Given /^a comment exists with content:(.*)$/ do |content|
  topic = Topic.first
  Factory(:comment, :commentable => topic, :content => content)
end

Then /^page title should contain (.*)$/ do |title|
  page.find('title').text.should include(title)
end

Then /^page title should not contain (.*)$/ do |title|
  page.find('title').should have_no_content(title)
end

When /^I click the link (.*)$/ do |link|
  click_link(link)
end

When /^I click the button (.*)$/ do |button|
  click_button(button)
end

When /^I click the mobile button (.*)$/ do |button|
  find_button(button).find(:xpath, '..').click
end

Then /^I can see that (.*) was mentioned in the comment$/ do |nickname|
  within('.reply_content') do
    page.should have_link(nickname)
  end
end

Then /^it should display personal homepage of (.*)$/ do |nickname|
  steps %Q(Then page title should contain #{nickname})
  steps %Q(Then I should see #{nickname})
  steps %Q(Then I should see 最近创建主题)
  steps %Q(Then I should see 最近参与主题)
end

Then /^it should display button (.*)$/ do |text|
  page.should have_button(text)
end

Given /^as an admin, I have logged in as (.*)$/ do |nickname|
  steps %Q(Given an admin exists with nickname: #{nickname})
  steps %Q(Given I have logged in as #{nickname})
end

Given /^as root, I have logged in as (.*)$/ do |nickname|
  steps %Q(Given a root exists with nickname: #{nickname})
  steps %Q(Given I have logged in as #{nickname})
end

Given /^(a|an) (.*) exists$/ do |i, model|
  Factory(model)
end

Then /^an alert message is shown as (.*)$/ do |text|
  assert page.driver.browser.switch_to.alert.text.include?(text)
end

When /^I confirm the alert message$/ do
  page.driver.browser.switch_to.alert.accept
end

Then /^it should display the search form$/ do
  page.should have_css("#Search input")
end

When /^I search for (.*)$/ do |query|
  fill_in "q", :with => query
  find("#q").native.send_key(:enter)
end

Then /^it will use configured search engine$/ do
  page.driver.browser.window_handles.length.should == 2
  new_window = page.driver.browser.window_handles.last
  page.driver.browser.switch_to.window new_window
  search_engine_url = Settings.search_engines[Settings.default_search_engine]
  current_url.should include(search_engine_url)
  current_url.should include('site')
end

Then /^it should display (\d+) notification(s?)$/ do |n, i|
  page.all("#Content table tr").size.should == n.to_i
end

Given /^a notification exists with user: (.*)$/ do |nickname|
  user = User.find_by_nickname(nickname)
  Factory(:notification, :user => user)
end

Then /^it should display link (.*)$/ do |link_text|
  page.should have_link(link_text)
end

Then /^it should not display link (.*)$/ do |link_text|
  page.should have_no_link(link_text)
end

Then /^it should not display button (.*)$/ do |link_text|
  page.should have_no_button(link_text)
end

Then /^I should be able to post a new comment$/ do
  steps %Q(When I add comment: 我爱北京天安门)
  steps %Q(Then I should be redirected to the topic page)
  steps %Q(And I should see 我爱北京天安门)
end

Then /^it should display a record not found message$/ do
  steps %Q(Then I should see 这个页面不存在哦)
end

