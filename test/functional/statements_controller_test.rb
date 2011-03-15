require 'test_helper'

class StatementsControllerTest < ActionController::TestCase
  def setup
    login_as :editor
    @controller = StatementsController.new
    flexmock(SocialService.instance).should_receive(:share_activities).with(Hash, Hash).and_return(['facebook', 'twitter'])
  end

  #####################
  # QUESTION MODULE #
  #####################

  test "should get discuss search" do
    get :category
    assert_response :success
  end

  test "should get discuss search with a value" do
    get :category, :search_terms => '#echonomyjam'
    assert_response :success
  end

  test "should get my questions" do
    get :my_questions
    assert_response :success
  end

  test "should publish non published debate" do
    prev_published = StatementNode.published(false).count
    put :publish, :id => statement_nodes(:non_published_question).to_param
    assert_equal StatementNode.published(false).count, prev_published+1
  end

  #####################
  # ECHOABLE MODULE   #
  #####################

  test "should echo statement node" do
    assert_difference('UserEcho.count', 1) do
      put :echo, :id => statement_nodes('first-proposal').to_param
    end
  end

  ########################
  # INCORPORATION MODULE #
  ########################

  test "should get incorporation form" do
    i = Improvement.first
    i.readify! ; i.stage! ; i.approve!
    get :incorporate, :id => statement_nodes('first-proposal').to_param, :approved_ip => i.to_param
    assert_response :success
  end


  ######################
  # TRANSLATION MODULE #
  ######################


  test "should translate the statement" do
    user = users(:editor)
    document = statement_documents('test-question-doc-english')
    document.lock(user)

    assert_difference('StatementDocument.count', 1) do
      I18n.locale = 'pt'
      put :create_translation,
       :id => statement_nodes('test-question').to_param,
       :question => { :statement_document =>{
                        :statement_id => statements('test-question-statement').to_param,
                        :language_id => Language[:en]
                      },
                      :new_statement_document => {
                        :title => "Translation in Portuguese",
                        :text => "És cruel, meteste a tua filha num bordel",
                        :action_id => StatementAction[:translated].id,
                        :locked_at => document.locked_at.to_s,
                        :old_document_id => document.to_param
                      },
                      :parent_id => nil,
                      :state_id => StatementState[:published].id
                    }
    end
  end

  ##############################

  test "should get to view the statement" do
    get :show, :id => statement_nodes('test-question').to_param
    assert_response :success
    get :show, :id => statement_nodes('first-proposal').to_param
    assert_response :success
    get :show, :id => statement_nodes('third-impro-proposal').to_param
    assert_response :success
  end

  test "should get to view the question teaser" do
    get :add, :type => :question
    assert_response :success
  end
  test "should get to view the proposal teaser" do
    get :add, :type => :proposal, :id => statement_nodes('test-question').to_param
    assert_response :success
  end
  test "should get to view the improvement teaser" do
    get :add, :type => :improvement, :id => statement_nodes('first-proposal').to_param
    assert_response :success
  end
  test "should get to view the pro argument teaser" do
    get :add, :type => :pro_argument, :id => statement_nodes('first-proposal').to_param
    assert_response :success
  end
  test "should get to view the contra argument teaser" do
    get :add, :type => :contra_argument, :id => statement_nodes('first-proposal').to_param
    assert_response :success
  end
  test "should get to view the follow-up question teaser" do
    get :add, :type => :follow_up_question, :id => statement_nodes('first-proposal').to_param
    assert_response :success
  end

  test "should get the new question form" do
    get :new, :type => :question
    assert_response :success
  end
  test "should get the new proposal form" do
    get :new, :id => statement_nodes('test-question').to_param, :type => :proposal
    assert_response :success
  end
  test "should get the new improvement form" do
    get :new, :id => statement_nodes('first-proposal').to_param, :type => :improvement
    assert_response :success
  end
  test "should get the new pro argument form" do
    get :new, :id => statement_nodes('first-proposal').to_param, :type => :pro_argument
    assert_response :success
  end
  test "should get the new contra argument form" do
    get :new, :id => statement_nodes('first-proposal').to_param, :type => :contra_argument
    assert_response :success
  end
  test "should get the new follow-up question form" do
    get :new, :id => statement_nodes('first-proposal').to_param, :type => :follow_up_question
    assert_response :success
  end


  test "should create new question" do
    assert_difference('Question.count', 1) do
      post :create, :type => "Question",
      :question => {
        :statement_document => {:title => "Super Question", :statement_id=> "", :text => "I am Sam", :language_id => Language[:en].id,
                                :action_id => StatementAction[:created].id , :locked_at => ""},
        :editorial_state_id => StatementState[:published].id,
        :statement_id => "",
        :parent_id => nil,
        :topic_tags => "" }
    end
  end
  
  test "shoud create proposal" do
    assert_difference('Proposal.count', 1) do
      post :create, :type => "Proposal", :echo => true,
      :proposal => {
        :statement_document => {:title => "Super Proposal", :statement_id=> "", :text => "I am Sam", :language_id => Language[:en].id,
                                :action_id => StatementAction[:created].id , :locked_at => ""},
        :editorial_state_id => StatementState[:published].id,
        :statement_id => "",
        :parent_id => statement_nodes('test-question').to_param }
    end
  end
  
  test "should create improvement" do
    assert_difference('Improvement.count', 1) do
      post :create, :type => "Improvement", :echo => true,
      :improvement => {
        :statement_document => {:title => "Super Improvement", :statement_id=> "", :text => "I am Sam", :language_id => Language[:en].id,
                                :action_id => StatementAction[:created].id , :locked_at => ""},
        :editorial_state_id => StatementState[:published].id,
        :statement_id => "",
        :parent_id => statement_nodes('first-proposal').to_param }
    end
  end
  test "should create pro argument" do
    assert_difference('ProArgument.count', 1) do
      post :create, :type => "ProArgument", :echo => true,
      :pro_argument => {
        :statement_document => {:title => "Super Pro Argument", :statement_id=> "", :text => "I am Sam", :language_id => Language[:en].id,
                                :action_id => StatementAction[:created].id , :locked_at => ""},
        :editorial_state_id => StatementState[:published].id,
        :statement_id => "",
        :parent_id => statement_nodes('first-proposal').to_param }
    end
  end
  test "should create contra argument" do
    assert_difference('ContraArgument.count', 1) do
      post :create, :type => "ContraArgument", :echo => true,
      :contra_argument => {
        :statement_document => {:title => "Super Contra Argument", :statement_id=> "", :text => "I am Sam", :language_id => Language[:en].id,
                                :action_id => StatementAction[:created].id , :locked_at => ""},
        :editorial_state_id => StatementState[:published].id,
        :statement_id => "",
        :parent_id => statement_nodes('first-proposal').to_param }
    end
  end
  test "should create follow up question" do
    assert_difference('FollowUpQuestion.count', 1) do
      post :create, :type => "FollowUpQuestion", :echo => true,
      :follow_up_question => {
        :statement_document => {:title => "Super Follow Up Question", :statement_id=> "", :text => "I am Sam", :language_id => Language[:en].id,
                                :action_id => StatementAction[:created].id , :locked_at => ""},
        :editorial_state_id => StatementState[:published].id,
        :statement_id => "",
        :parent_id => statement_nodes('first-proposal').to_param }
    end
  end

  test "should get the edit question form" do
    get :edit, :id => statement_nodes('test-question').to_param, :type => :question, :current_document_id => statement_documents('test-question-doc-english').to_param
    assert_response :success
  end
  test "should get the edit proposal form" do
    get :edit, :id => statement_nodes('first-proposal').to_param, :type => :proposal, :current_document_id => statement_documents('first-proposal-doc-english').to_param
    assert_response :success
  end
  test "should get the edit improvement form" do
    get :edit, :id => statement_nodes('third-impro-proposal').to_param, :type => :improvement, :current_document_id => statement_documents('third-impro-proposal-doc-english').to_param
    assert_response :success
  end
  test "should not get the edit question form" do
    get :edit, :id => statement_nodes('test-question').to_param, :type => :question, :current_document_id => 0
    assert_template 'statements/show'
    assert_response :success
  end



  test "should get more argument children" do
    get :more, :id => statement_nodes('first-proposal').to_param, :type => "argument"
    assert_not_nil assigns(:children)
    assert assigns(:children).size, 5
    assert_not_nil assigns(:children_documents)
    assert_response :success
  end

  test "should get more children" do
    get :children, :id => statement_nodes('test-question').to_param, :type => "proposal"
    assert_not_nil assigns(:children)
    assert assigns(:children).size, 7
    assert_not_nil assigns(:children_documents)
    assert_response :success
  end
  
  test "should get statements descendants" do
    get :descendants, :id => statement_nodes('test-question').to_param, :type => "proposal", :current_node => statement_nodes('second-proposal').to_param
    assert_not_nil assigns(:children)
    assert assigns(:children).size, 7
    assert_not_nil assigns(:children_documents)
    assert_response :success
  end

  test "should get the statement node authors" do
    @statement_node = Question.first
    get :authors,:id => @statement_node.id
    assert_not_nil assigns(:authors)
    assert assigns(:authors).size, @statement_node.authors.size
    assert_response :success
  end


  test "should get me the right parents list" do
    get :ancestors, :id => statement_nodes('first-impro-proposal').to_param
    assert assigns(:statement_ids).include?(statement_nodes('test-question-2').to_param.to_i)
    assert assigns(:statement_ids).include?(statement_nodes('first-proposal').to_param.to_i)
    assert_response :success
  end
  
  
  ########################
  # SOCIAL SHARING TESTS #
  ########################
  
  test "should not get social widget bcuz im not a supporter of this statement" do
    get :social_widget, :id => statement_nodes('test-question').to_param
    assert assigns(:info).eql?(I18n.t("discuss.statements.supporter_to_share"))
    assert_response :success
  end
  
  test "should get social widget" do
    statement_nodes('test-question').supported!(users(:editor))
    get :social_widget, :id => statement_nodes('test-question').to_param
    assert assigns(:proposed_url).include?("http://#{ECHO_HOST}/test-question")
    assert assigns(:proposed_url).include?(tags('echonomy-jam').value)
    assert_response :success
  end
  
  test "should get social widget and message must have the hash tag of root" do
    statement_nodes('second-proposal').supported!(users(:editor))
    get :social_widget, :id => statement_nodes('second-proposal').to_param
    assert assigns(:proposed_url).include?("http://#{ECHO_HOST}/second-proposal")
    assert assigns(:proposed_url).include?(tags('echonomy-jam').value)
    assert_response :success
  end
  
  test "should not share bcuz i'm not a supporter of this statement" do
    assert_difference('ShortcutUrl.count', 0) do
      post :share, {:id => statement_nodes('test-question').to_param,
                    :providers => {'facebook' => 'enabled', 'twitter' => 'enabled'},
                    :text => "i would like to make an echo"
                    }
      assert_nil assigns(:shortcut_url)
      assert assigns(:info).eql?(I18n.t("discuss.statements.supporter_to_share"))
    end
  end
  
  test "should share message to twitter and facebook account" do
    statement_nodes('test-question').supported!(users(:editor))
    assert_difference('ShortcutUrl.count', 1) do
      post :share, {:id => statement_nodes('test-question').to_param,
                    :providers => {'facebook' => 'enabled', 'twitter' => 'enabled'},
                    :text => "i would like to make an echo"
                    }
      assert_not_nil assigns(:shortcut_url)
      assert assigns(:shortcut_url).shortcut.eql?("test-question") 
      assert assigns(:providers_success).include?('facebook')
      assert assigns(:providers_success).include?('twitter')
      assert assigns(:providers_failed).empty?
    end
  end
  
  test "should share message to twitter and facebook account, but fail to share to linked_in" do
    statement_nodes('test-question').supported!(users(:editor))
    assert_difference('ShortcutUrl.count', 1) do
      post :share, {:id => statement_nodes('test-question').to_param,
                    :providers => {'facebook' => 'enabled', 'twitter' => 'enabled', 'linked_in' => 'enabled'},
                    :text => "i would like to make an echo"
                    }
      assert_not_nil assigns(:shortcut_url)
      assert assigns(:shortcut_url).shortcut.eql?("test-question") 
      assert assigns(:providers_success).include?('facebook')
      assert assigns(:providers_success).include?('twitter')
      assert assigns(:providers_failed).include?('linked_in')
    end
  end
  
end
