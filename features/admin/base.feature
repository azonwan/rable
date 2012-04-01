Feature: Admin
  Scenario: show dashboard
    Given as an admin, I have logged in as devin
      And I am on the home page
      Then I should see 管理后台
      When I click the link 管理后台
      Then page title should contain 管理后台
        And I should see 页面
        And I should see 主题
        And I should see 用户
        And I should see 广告位

