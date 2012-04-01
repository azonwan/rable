Feature: Homepage

  Scenario: browse homepage as an anonymous user
    Given I am not authenticated
      And I am on the home page
      Then I should see 注册
        And I should see 登入

  Scenario: I should not see sign in and register links when logged in
    Given I have logged in as devin
      And I am on the home page
      Then I should see devin
        And I should see 设置
        And I should see 登出
        And it should not display link 注册
        And I should not see 登入

  Scenario: browse homepage as authenticated user
    Given I have logged in as devin
      And I am on the home page
      Then I should see devin
        And I should see 节点收藏
        And I should see 主题收藏
        And I should see 特别关注

  Scenario: nodes and topics on homepage
    Given a node exists with name: 电影
      And a topic under the node exists with title: 全球最佳电影推荐
      And a comment exists with content: 这些电影都想看!
      And I am on the home page
      Then I should see 电影
        And I should see 全球最佳电影推荐
        And I should see 1

  Scenario: visit my bookmarked nodes
    Given I have logged in as devin
      And I have bookmarked 2 nodes
      When I am on the home page
      Then I should see 节点收藏
      When I click the link 节点收藏
      Then page title should contain 我收藏的节点
        And I should see 我收藏的节点
        And it should display 2 bookmarked nodes

  Scenario: visit my bookmarked topics
    Given I have logged in as devin
      And I have bookmarked 2 topics
      When I am on the home page
      Then I should see 主题收藏
      When I click the link 主题收藏
      Then page title should contain 我收藏的主题
        And I should see 我收藏的主题
        And it should display 2 bookmarked topics

  Scenario: more topics and all topics
    Given I am on the home page
    Then I should see 更多新主题
    When I click the link 更多新主题
    Then page title should contain 最近的 50 个主题
      And I should see 最近的 50 个主题
      And I should see 继续浏览全站最新更改记录
      When I click the link 继续浏览全站最新更改记录
      Then page title should contain 全站最新更改记录
        And I should see 全站最新更改记录

  Scenario: show nav pages in bottom
    Given 3 pages exist
      And I am on the home page
      Then 3 page nav links shold be shown

  @javascript
  Scenario: search
    Given I am on the home page
      Then it should display the search form
      When I search for rails
        Then it will use configured search engine

