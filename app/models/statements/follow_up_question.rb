class FollowUpQuestion < StatementNode

  belongs_to :question, :dependent => :destroy

  delegate :level, :ancestors, :topic_tags, :topic_tags=, :tags, :taggable?, :echoable?, :editorial_state_id,
           :editorial_state_id=, :publishable?, :published, :locked_at, :supported?, :taggable?, :creator_id=,
           :creator_id, :creator, :author_support, :ancestors, :target_id, :to => :question

  validates_associated :question

  def target_statement
    self.question
  end

  def set_statement(attrs={})
    self.statement = self.question.statement = Statement.new(attrs)
  end

  #################################################
  # string helpers (acts_as_echoable overwriting) #
  #################################################

  class << self
    def children_types(visibility = false, default = true, expand = false)
      Question.children_types(visibility, default, expand)
    end

    def new_instance(attributes = nil)
      parent = attributes ? attributes.delete(:parent_id) : nil
      root = attributes.delete(:root_id)
      question = Question.new_instance(attributes)
      self.new({:parent_id => parent,
                :root_id => root,
                :question => question,
                :creator => question.creator,
                :echo => question.echo,
                :statement => question.statement})
    end

    # helper function to differentiate this model as a level 0 model
    def is_top_statement?
      true
    end

    def children_joins
      " LEFT JOIN #{Statement.table_name} ON #{self.table_name}.statement_id = #{Statement.table_name}.id"
    end

    def children_conditions(opts)
      parent = StatementNode.find opts[:parent_id]
      conditions = ""
      conditions << sanitize_sql(["(#{Statement.table_name}.editorial_state_id = ? OR #{self.table_name}.creator_id = ?) AND ",
                                  StatementState['published'].id, opts[:user] ? opts[:user].id : -1])
      conditions << sanitize_sql(["#{self.table_name}.type = ? AND
                                   #{self.table_name}.root_id = ? AND
                                   #{self.table_name}.lft >= ? AND #{self.table_name}.rgt <= ? ",
                                   self.name, parent.root_id, parent.lft, parent.rgt])
    end

    #################################################
    # string helpers (acts_as_echoable overwriting) #
    #################################################

    def support_tag
      "recommend"
    end

    def unsupport_tag
      "unrecommend"
    end
  end

end