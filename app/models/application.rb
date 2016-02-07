class Application < ActiveRecord::Base
  has_paper_trail

  belongs_to :user
  belongs_to :membership

  has_one :state
end
