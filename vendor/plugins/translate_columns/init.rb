# Include hook code here

require 'translate_columns'

ActiveRecord::Base.class_eval do
  include TranslateColumns
end
