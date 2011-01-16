module EchoableModuleHelper

  # Inserts a status bar based on the support ratio value.
  # (The support ratio is the calculated ratio for a statement_node,
  # representing and visualizing the agreement a statement_node has found within the community.)
  def supporter_ratio_bar(statement_node,
                          show_label = false,
                          previous_statement = statement_node.parent,
                          type = statement_node.class.name)
    # TODO:How to spare calculating this label two times (see next method, they're almost always sequencially triggered)
    if show_label
      label = supporters_number(statement_node)
    end

    extra_classes = show_label ? 'supporters_bar ttLink' : 'supporters_bar'
    if !statement_node.nil? and (statement_node.new_record? or statement_node.ratio(previous_statement,type) > 1)
      content_tag(:span, '', :class => "echo_indicator #{extra_classes}", :title => label,
                  :alt => statement_node.new_record? ? 10 : statement_node.ratio(previous_statement,type))
    else
      content_tag(:span, '', :class => "no_echo_indicator #{extra_classes}",:title => label)
    end
  end


  # Inserts a supporters label with the supporters number of this statement
  def supporters_label(statement_node, show_label = false)
    return unless show_label
    label = supporters_number(statement_node)
    content_tag(:span, label, :class => "supporters_label")
  end


  # Returns the right line that shows up below the ratio bar (1 supporter, 2 supporters...)
  def supporters_number(statement_node)
    I18n.t("discuss.statements.echo_indicator.#{ statement_node.supporter_count <= 1 ? 'one' : 'many'}",
           :supporter_count => statement_node.new_record? ? 1 : statement_node.supporter_count)
  end


  # Renders the button for echo and unecho.
  def render_echo_button(statement_node, echo = true, type = dom_class(statement_node))
    return if !statement_node.echoable?
    content = ''
    content << content_tag(:div, :class => 'echo_button') do
      if statement_node.new_record?
        content_tag :div, :class => 'echo_button_icon' do
          echo_content = ''
          echo_content << echo_tag(false, 'new_record')
          echo_content << hidden_field_tag('echo', true)
          echo_content
        end
      else
        link_to(echo ? echo_statement_node_url(statement_node) : unecho_statement_node_url(statement_node),
                           :class => "echo_button_icon ajax_put", :id => "echo_button") do
          echo_tag(echo)
        end
      end
    end
    content
  end


  # Renders the echo/unecho button element.
  def echo_tag(echo, extra_classes = '')
    title = I18n.t("discuss.tooltips.#{echo ? '' : 'un'}echo")
    content_tag :span, '',
                :class => "#{echo ? 'not_' : '' }supported ttLink no_border #{extra_classes}",
                :title => "#{title}"
  end
end