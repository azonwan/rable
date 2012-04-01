Feature: Bookmarks

  Background:
    Given I have logged in as devin

  Scenario: bookmark node
    Given a node exists with name: 电影
    And I am on the node page
    Then I should see 加入收藏
    When I click the link 加入收藏
      Then I should be redirected to the node page
      And I should see 取消收藏

  Scenario: bookmark topic
    Given a topic exists with title: Hi
    And I am on the topic page
    Then I should see 加入收藏
    When I click the link 加入收藏
      Then I should be redirected to the topic page
      And I should see 取消收藏

  Scenario: cancel bookmark node
    Given a node exists with name: 电影
      And I have bookmarked this node
      And I am on the node page
      Then I should see 取消收藏
      When I click the link 取消收藏
      Then I should be redirected to the node page
      And I should see 加入收藏

  Scenario: cancel bookmark topic
    Given a topic exists with title: Hi
      And I have bookmarked this topic
      And I am on the topic page
      Then I should see 取消收藏
        And I should see 已有 1 人收藏此主题
      When I click the link 取消收藏
      Then I should be redirected to the topic page
      And I should see 加入收藏
        And I should not see 已有
        And I should not see 收藏此主题


