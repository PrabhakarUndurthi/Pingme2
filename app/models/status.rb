class Status < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user


  #validating the user content and minimum characters to the post ..i.e two.
  validates :content, presence: true,
                      length: { minimum: 2 }

  validates :user_id, presence: true
                  #    length: { minimum:2 }

    
end
