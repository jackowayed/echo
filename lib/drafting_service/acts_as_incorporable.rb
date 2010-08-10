module ActiveRecord
  module Acts
    module Incorporable
      def self.included(base)
        base.extend(ClassMethods)
        base.instance_eval do
          include InstanceMethods
        end
      end
      
      module InstanceMethods
        def incorporable?
          false
        end
      end
    
      module ClassMethods
        
        def acts_as_incorporable(*args)
          
          class_eval do
            
            has_one  :drafting_info, :foreign_key => 'statement_node_id', :dependent => :destroy
            delegate :times_passed,  :times_passed=, :state_since, :state_since=, :to => :drafting_info
            
            validates_associated :drafting_info
            # Acts as State Machine plugin
            acts_as_state_machine :initial => :tracked, :column => 'drafting_state'
            
            # These are all of the states for the existing system.
            state :tracked
            state :ready
            state :staged
            state :approved
            state :incorporated
          
            event :track do
              transitions :from => :ready, :to => :tracked
              transitions :from => :staged, :to => :tracked
              transitions :from => :approved, :to => :tracked
            end
          
            event :readify do
              transitions :from => :tracked, :to => :ready
              transitions :from => :staged, :to => :ready
            end
            event :stage do
              transitions :from => :ready, :to => :staged
              transitions :from => :approved, :to => :staged
            end
            event :approve do
              transitions :from => :staged, :to => :approved
            end
            event :incorporate do
              transitions :from => :approved, :to => :incorporated
            end
          end
          
          class_eval <<-RUBY
          
            ####################################
            ###### Static values ###############
            ####################################
            
            def after_initialize
              self.drafting_info = DraftingInfo.new if self.drafting_info.nil? 
            end
            
            def incorporable?
              true
            end
            
            def min_votes?
              visitor_count > self.class.min_votes
            end
            
            def min_quorum?
              quorum > self.class.min_quorum
            end
            
            # Returns Ratio between number of supporters and number of visitors
            def quorum
              (supporter_count.to_i/parent.supporter_count.to_i)*100
            end
          RUBY
        end
      end
    end
  end
end