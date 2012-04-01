Feature: Comments

  Scenario: create comment when signed in
    Given I have logged in as devin
    And a topic exists with title: Hi
    And I am on the topic page
    Then it should display a comment form
      And I should be able to post a new comment

