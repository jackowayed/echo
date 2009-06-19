class StaticContentController < ApplicationController
  
  # Default page redirected to echoLogic - The Mission
  def index
    redirect_to(:action => 'echologic')
  end
  
  # Start page: echoLogic - The Mission
  def echologic
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # echo - The Platform
  def echo
    respond_to do |format|
      format.html { render :partial => 'static_content/echo', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo' } }            
    end
  end
  
  # echo - Discuss
  def echo_discuss
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_discuss', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo', :submenu_item => 'discuss' } }
    end
  end

  #echo - Connect
  def echo_connect
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_connect', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo', :submenu_item => 'connect' } }      
    end
  end

  #echo - Act
  def echo_act
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_act', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo', :submenu_item => 'act' } }
    end
  end
  
  # echocracy - The Actors
  def echocracy
    respond_to do |format|
      format.html { render :partial => 'static_content/echocracy', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echocracy' } } 
    end
  end

  # echocracy - Engaged Citizens
  def echocracy_citizens
    respond_to do |format|
      format.html { render :partial => 'static_content/echocracy_citizens', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echocracy', :submenu_item => 'citizens' } }            
    end
  end
  
  # echocracy - Experts & Scientists
  def echocracy_experts
    respond_to do |format|
      format.html { render :partial => 'static_content/echocracy_experts', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echocracy', :submenu_item => 'experts' } }            
    end
  end
  
  # echocracy - Organisations
  def echocracy_organisations
    respond_to do |format|
      format.html { render :partial => 'static_content/echocracy_organisations', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echocracy', :submenu_item => 'organisations' } }              
    end
  end
  
  # echonomy - The Philosophy
  def echonomy
    respond_to do |format|
      format.html { render :partial => 'static_content/echonomy', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echonomy' } }     
    end
  end
  
  # echonomy - Your-profit
  def echonomy_business_model
    respond_to do |format|
      format.html { render :partial => 'static_content/echonomy_business_model', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echonomy', :submenu_item => 'business_model' } }      
    end
  end
  
  # echonomy - Foundation
  def echonomy_foundation
    respond_to do |format|
      format.html { render :partial => 'static_content/echonomy_foundation', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echonomy', :submenu_item => 'foundation' } }            
    end
  end

  # echonomy - Public Property
  def echonomy_public_property
    respond_to do |format|
      format.html { render :partial => 'static_content/echonomy_public_property', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echonomy', :submenu_item => 'public_property' } }            
    end    
  end

  # echo on waves - The Project
  def echo_on_waves
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_on_waves', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo_on_waves' } }
    end
  end

  # echo on waves - Win Win
  def echo_on_waves_win_win
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_on_waves_win_win', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo_on_waves', :submenu_item => 'win_win' } }            
    end
  end
  
  # echo on waves - Open Source
  def echo_on_waves_open_source
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_on_waves_open_source', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo_on_waves', :submenu_item => 'open_source' } }                  
    end
  end

  # echo on waves - Joint effort
  def echo_on_waves_joint_effort
    respond_to do |format|
      format.html { render :partial => 'static_content/echo_on_waves_joint_effort', :layout => 'static' }
      format.js { render :template => 'static_content/static_content' , :locals => { :menu_item => 'echo_on_waves', :submenu_item => 'joint_effort' } }                  
    end
  end

end
