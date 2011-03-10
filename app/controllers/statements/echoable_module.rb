module EchoableModule
  ###################
  # ECHO STATEMENTS #
  ###################

  #
  # Called if user supports this statement_node. Updates the support field in the corresponding
  # echo object.
  #
  # Method:   POST
  # Response: JS
  #
  def echo
    begin
      return if !@statement_node.echoable?
      if !@statement_node.incorporable? or @statement_node.parent.supported?(current_user)
        @statement_node.supported!(current_user)
        set_statement_info('discuss.statements.statement_supported')
        respond_to_js :redirect_to => statement_node_url(@statement_node), :template_js => 'statements/echo'
      else
        set_info('discuss.statements.unsupported_parent')
        render_statement_with_info
      end
    rescue Exception => e
      log_error_statement(e, "Error echoing statement node '#{@statement_node.id}'.")
    else
      log_message_info("Statement node '#{@statement_node.id}' has been echoed sucessfully.")
    end
  end

  #
  # Called if user doesn't support this statement_node any longer. Sets the supported field
  # of the corresponding echo object to false.
  #
  # Method:   POST
  # Response: HTTP or JS
  #
  def unecho
    begin
      return if !@statement_node.echoable?

      @statement_node.unsupported!(current_user)
      
      
      if @statement_node.draftable?
        @statement_node.children.each{|c|c.unsupported!(current_user) if c.incorporable? and c.supported?(current_user)}
      end
      
      # Logic to update the children caused by cascading unsupport
      @page = params[:page] || 1
      set_statement_info('discuss.statements.statement_unsupported')
      respond_to_js :redirect_to => statement_node_url(@statement_node),
                    :template_js => 'statements/unecho'
    rescue Exception => e
      log_error_statement(e, "Error unechoing statement node '#{@statement_node.id}'.")
    else
      log_message_info("Statement node '#{@statement_node.id}' has been unechoed sucessfully.")
    end
  end
  
  #
  # Called if user wants to share his echo in his social networks. 
  #
  # Method:   GET
  # Response: HTTP or JS
  #
  def social_widget
    begin
      if @statement_node.supported?(current_user)
        @statement_document ||= @statement_node.document_in_preferred_language(@language_preference_list)
        @title = "made an"
        @proposed_url = "http://#{ECHO_HOST}/#{ShortcutUrl.truncate(@statement_document.title)}"
  #      command = {:operation => "statement_node", :params => {:id => @statement_node.id}, :language => @statement_document.language.code}.to_json
  #      @shortcut_url = ShortcutUrl.find_or_create(:shortcut => @statement_document.title, 
  #                                                 :human_readable => true, :shortcut_command => {:command => command})
        respond_to do |format|
          format.js { render :template => "statements/social_widget" }
        end
      else
        set_info "discuss.statements.supporter_to_share"
        render_statement_with_info
      end
    rescue Exception => e
      log_error_statement(e, "Error getting social widget for statement node '#{@statement_node.id}'.")
    else
      log_message_info("Statement node '#{@statement_node.id}' has loaded widget sucessfully.")
    end
  end

  #
  # Called if user shares his echo in his social networks. Creates a shortcut url for this.
  #
  # Method:   POST
  # Response: HTTP or JS
  #
  def share
    begin 
      @statement_document ||= @statement_node.document_in_preferred_language(@language_preference_list)
      command = {:operation => "statement_node", :params => {:id => @statement_node.id}, :language => @statement_document.language.code}.to_json
      @shortcut_url = ShortcutUrl.find_or_create(:shortcut => @statement_document.title, 
                                                 :human_readable => true, :shortcut_command => {:command => command})
      if @shortcut_url
        provider_states = params[:providers]
        opts = {}
        opts[:url] = "http://#{ECHO_HOST}/#{@shortcut_url.shortcut}"
        opts[:action] = "#{params[:text].strip}"
        opts[:action_links] = [I18n.t("application.general.share_comment")]
        opts[:images] = []
        opts[:images] << "http://#{ECHO_HOST}/#{@statement_node.image.url(:medium)}" if @statement_node.image.exists?
        #insert default image in this line
        opts[:title] = @statement_document.title
        opts[:description] = "#{@statement_document.text[0,255]}..."
        
        providers = %w(facebook twitter yahoo! linked_in)
        providers.reject!{|p|provider_states[p].nil? || provider_states[p].eql?('disabled')}
        providers_hash = providers.each_with_object({}) {|prov, hash|
          social = current_user.has_provider?(prov)
          hash[prov] = social if social
        }
        providers_success = SocialService.instance.share_activities(providers_hash, opts)
        providers_failed = providers - providers_success
        respond_to do |format|
          %w(success failed).each do |state|
            providers_state = eval("providers_#{state}")
            set_info("users.social_accounts.share.#{state}", 
                   :accounts => providers_state.map{|c|I18n.t("users.social_accounts.providers.#{c}")}.join("/")) if !providers_state.empty?
          end
          
          format.html{flash_info and redirect_to @statement_node}
          format.js {
            render_with_info do |page|
              page << "$('#statements .#{dom_class(@statement_node)} .social_echo_panel').fadeOut();"
            end
          }
        end
      else
        respond_to do |format|
          set_error @shortcut_url
          format.html {set_error and redirect_to @statement_node}
          format.js {render_with_error}
        end
      end
    rescue Exception => e
      log_error_statement(e, "Error getting social widget for statement node '#{@statement_node.id}'.")
    else
      log_message_info("Statement node '#{@statement_node.id}' has loaded widget sucessfully.")
    end
  end

  protected
  #
  # Loads the echo/unecho messages as JSON data to handled on the client
  #
  def load_echo_info_messages
    @messages = {:supported => set_statement_info('discuss.statements.statement_supported'),
                 :not_supported => set_statement_info('discuss.statements.statement_unsupported')}.to_json
  end
  

  def is_echoable?
    @statement_node.echoable?
  end
end