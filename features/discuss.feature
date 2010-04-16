          @discuss @UserSession
Feature: Take Part on a discussion
  In order to take part on a discussion
  As a user
  I want to give different kind of statements on questions


  # Within the discuss area the list of debates should be
  # correctly ordered (by date of creation)

  # FIXME this can't work in this way, and should anyway rather being tested inside a functional test

  # Scenario: View debates list
  #   Given I am logged in as "user" with password "true"
  #   And I am on the Discuss Index
  # 	When I follow "Featured"
  # 	When I follow "echonomy JAM"
  #   	When I choose the first Question
  #   	When I choose the second Question
  #   Then the second question must be more recent than the first question
        
    
  @ok
  Scenario: Open a question
    Given I am logged in as "user" with password "true"
      And I am on the Discuss Index
    When I follow "Featured"
    When I follow "echonomy JAM"
      And I choose the first Question
    Then I should see the questions title
  
  @ok
  Scenario: Add a proposal to a question
    Given I am logged in as "user" with password "true"
      And there is the first question
      And the question has no proposals
      And I am on the Discuss Index
    When I follow "Featured"
    When I follow "echonomy JAM"
      And I choose the first Question
      And I follow "create_proposal_link"
      And I fill in the following:
        | proposal_document_title | a proposal to propose some proposeworthy proposal data |
        | proposal_document_text | nothing to propose yet...                              |
      And I press "Save"
      Then I should see "a proposal to propose some"
      And the question should have one proposal

  @ok
  Scenario: Add an Improvement Proposal to a Proposal
    Given I am logged in as "user" with password "true"
      And there is the first question
      And the question has at least on proposal
    When I go to the questions first proposal
      And I follow "create_improvement_proposal_link"
      And I fill in the following:
      | improvement_proposal_document_title           | Improving the unimprovable                                           |
      | improvement_proposal_document_text           | blubb (oh, and of cause a lot of foo and a little bit of (mars-)bar) |
      And I press "Save"
    Then I should see "Improving the unimprovable"
      And the proposal should have one improvement proposal

  @ok
  Scenario: Edit a proposal i created
    Given I am logged in as "user" with password "true"
      And there is a proposal I have created
     When I go to the proposal
     Then I should not see "Edit"
   #   And I follow "edit"
   #   And I fill in the following:
   #    | title | my updated proposal               |
   #    | text  | somewhat more to propose at lease |
   #   And I press "Save"
   # Then I should see "my updated proposal"
   #   And the questions title should be "my updated proposal"

   Scenario: View a proposal
     Given I am logged in as "user" with password "true"
       And there is a proposal
     When I go to the proposal
     Then I should see localized "discuss.summary"
       And I should see the proposals data
       And I should see localized "discuss.statements.create_improvement_proposal_link"
       And I should see localized "discuss.statements.create_proposal_link"
