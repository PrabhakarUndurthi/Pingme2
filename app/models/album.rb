class Album < ActiveRecord::Base
  belongs_to :user
  has_many :pictures
  attr_accessible :title
end
