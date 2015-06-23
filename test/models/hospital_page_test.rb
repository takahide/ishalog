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

require 'test_helper'

class HospitalPageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
