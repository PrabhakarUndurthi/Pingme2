class Album < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title
  attr_accessible :title
end
