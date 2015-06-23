# == Schema Information
#
# Table name: hospital_pages
#
#  id         :integer          not null, primary key
#  prefecture :string(255)
#  page       :integer
#  html       :text
#  created_at :datetime
#  updated_at :datetime
#

class HospitalPage < ActiveRecord::Base
end
