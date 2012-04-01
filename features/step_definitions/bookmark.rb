Given /^I have bookmarked this node$/ do
  user = User.first
  node = Node.first
  Factory(:bookmark, :user => user, :bookmarkable => node)
end

Given /^I have bookmarked this topic$/ do
  user = User.first
  topic = Topic.first
  Factory(:bookmark, :user => user, :bookmarkable => topic)
end

Given /^I have bookmarked (\d+) nodes$/ do |n|
  u = User.first
  n.to_i.times do
    node = Factory(:node)
    Factory(:bookmark, :user => u, :bookmarkable => node)
  end
end

Then /^it should display (\d+) bookmarked nodes$/ do |n|
  page.should have_css('td tr', :count => n.to_i)
end

Given /^I have bookmarked (\d+) topics$/ do |n|
  u = User.first
  n.to_i.times do
    topic = Factory(:topic)
    Factory(:bookmark, :user => u, :bookmarkable => topic)
  end
end

Then /^it should display (\d+) bookmarked topics$/ do |n|
  page.should have_css('td.avatar', :count => n.to_i)
end
