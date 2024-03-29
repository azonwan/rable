Feature: Manage Nodes

  @javascript
  Scenario: add node
    Given a plane exists
      And as an admin, I have logged in as devin
      When I am on the admin planes page
      Then it should display link 添加节点
        When I click the link 添加节点
        Then it should display the node creation form
        When I try to provide node info with name: Nginx
          Then I should see Nginx
          And it should display link 修改节点

  @javascript
  Scenario: edit node
    Given a node exists
      And as an admin, I have logged in as devin
      When I am on the admin planes page
      Then it should display link 修改节点
      When I click the link 修改节点
        Then it should display the node editing form
        When I try to provide node info with name: Nginx
          Then I should see Nginx
