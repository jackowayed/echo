module PublishableModuleHelper
  #
  # get the text that shows up on the top left corner of discuss search results
  #
  def questions_count_text(count, search_terms = nil)
    text = count_text("discuss", count)
    text << " #{I18n.t('discuss.for', :value => search_terms)}" if search_terms
    text
  end


  #
  # create question button above the discuss search results and on the left corner of my questions
  #
  def create_question_link_for(origin, search_terms=nil)
    origin = search_terms.blank? ? :ds : :sr
    bids = setBreadcrumbStack :origin => origin, :search_terms => search_terms
    origin = "#{origin}=>#{search_terms}"if !search_terms.blank?
    bids = !bids.nil? ? bids.join(',') : nil
    link_to(new_question_url(:origin => origin, :search_terms => search_terms, :bids => bids),
            :id => 'create_question_link') do
      content_tag(:span, '',
                  :class => "new_question create_statement_button_mid create_question_button_mid ttLink no_border",
                  :title => I18n.t("discuss.tooltips.create_question"))
    end
  end
  
  
  #
  # question link for the discuss search results
  #
  def link_to_question(title, question,long_title,search_terms=nil)
    origin = search_terms.blank? ? :ds : :sr
    bids = setBreadcrumbStack :origin => origin, :search_terms => search_terms
    origin = "#{origin}=>#{search_terms}"if !search_terms.blank?
    origin = bids ? bids.last : nil
    bids = bids ? bids.join(',') : nil
    link_to statement_node_url(question, :origin => origin, :bids => bids),
               :title => "#{h(title) if long_title}",
               :class => "avatar_holder#{' ttLink no_border' if long_title }" do 
      image_tag question.image.url(:small)
    end
  end
  

  #
  # Creates a link to create a new question
  # Appears in add question teaser
  #
  def create_new_question_link(origin=nil)
    origin = origin ? origin.split(',') : [nil]
    bids = setBreadcrumbStack :origin => origin[0], :search_terms => origin[0]==:sr ? origin[1] : ''
    bids = bids ? bids.join(',') : nil
    link_to(I18n.t("discuss.statements.create_question_link"),
            new_question_url(:origin => origin, :bids => bids),
            :id => "create_question_link",
            :class => "ajax add_new_button text_button create_question_button ttLink no_border",
            :title => I18n.t("discuss.tooltips.create_question"))
  end

  #
  # Creates a button link to create a new question (SIDEBAR).
  #
  def add_new_question_button(origin = nil)
    origin = origin.nil? ? [nil] : origin.split('=>')
    bids = setBreadcrumbStack :origin => origin[0], :search_terms => origin[0]==:sr ? origin[1] : ''
    bids = bids ? bids.join(',') : nil
    link_to(I18n.t("discuss.statements.types.question"),
            new_question_url(:origin => origin, :bids => bids),
            :id => "add_new_question_link", :class => "question_link resource_link ajax")   
  end
  

  #
  # publish button that appears on the right top corner of the statement 
  #
  def publish_statement_node_link(statement_node, statement_document)
    if current_user and
       statement_document.author == current_user and !statement_node.published?
      link_to(I18n.t('discuss.statements.publish'),
              { :controller => :statements, :id => statement_node.id, :action => :publish, :in => :summary },
              :id => 'publish_button', 
              :class => 'ajax_put header_button text_button publish_text_button ttLink',
              :title => I18n.t('discuss.tooltips.publish'))
    else
      ''
    end
  end
  
  #
  # linked title of question on my question area 
  #
  def my_issue_title(title,question)
    bids = setBreadcrumbStack :origin => :mi, :search_terms => nil
    bids = bids ? bids.join(',') : nil
    link_to(h(title),statement_node_url(question, :origin => :mi, :bids => bids), :class => "statement_link ttLink no_border",
            :title => I18n.t("discuss.tooltips.read_#{question.class.name.underscore}")) 
  end
  
  #
  # linked image of question on my question area 
  #
  def my_issue_image(question)
    bids = setBreadcrumbStack :origin => :mi, :search_terms => nil
    bids = bids ? bids.join(',') : nil
    link_to statement_node_url(question, :origin => :mi, :bids => bids), :class => "avatar_holder" do
      image_tag question.image.url(:small)
    end 
  end

  # Creates a 'Publish' button to release the question on my questions area.
  def publish_button_or_state(statement_node)
    if !statement_node.published?
      link_to(I18n.t("discuss.statements.publish"),
              publish_statement_node_path(statement_node),
              :class => 'ajax_put publish_button ttLink',
              :title => I18n.t('discuss.tooltips.publish'))
    else
      "<span class='publish_button'>#{I18n.t('discuss.statements.states.published')}</span>"
    end
  end
  
  # returns a collection from possible statement states to be used on radios and select boxes
  def statement_states_collection
    StatementState.all.map{|s|[I18n.t("discuss.statements.states.initial_state.#{s.code}"),s.id]}
  end
end