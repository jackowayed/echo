namespace :create_shortcuts do
  desc "Turns on newsletter notifications for all users"
  task :vision_summit_2011 => :environment do
    %w(vs11 vision-summit visionsummit).each do |shortcut|
      ShortcutUrl.discuss_search_shortcut :title => shortcut,
                                          :params => {:search_terms => "#vs11 dep"},
                                          :language => "de"
    end
    %w(vf11 vision-fair visionfair).each do |shortcut|
      ShortcutUrl.discuss_search_shortcut :title => shortcut,
                                          :params => {:search_terms => "vision fair"},
                                          :language => "de"
    end
  end
end