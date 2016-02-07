class Membership < ActiveRecord::Base
  serialize :entry, Array

  has_many :applications
end
