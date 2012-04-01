Feature: Manage Users

  Scenario: show all users
    Given as root, I have logged in as devin
      And an user exists with nickname: nana
      And an admin exists
      When I am on the admin users page
        Then page title should contain 用户
          And I should see 权限
          And I should see 操作
          And it should display link 提升为管理员
          And it should display link 取消管理权限

  @javascript
  Scenario: only root can manage admins
    Given a root exists with nickname: devin
      And an user exists with nickname: zhiming
      And as an admin, I have logged in as nana
      When I am on the admin users page
        Then page title should contain 用户
          And I should see 角色
          And I should see 操作
          And it should not display link 提升为管理员
          And it should not display link 取消管理权限
          When I logout
          Given I have logged in as devin
            And I am on the admin users page
              Then it should display link 提升为管理员
              When I click the link 提升为管理员
              Then it should not display link 提升为管理员

