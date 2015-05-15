# == Schema Information
#
# Table name: recommendations
#
#  id         :integer          not null, primary key
#  uid        :string(255)
#  doctor     :string(255)
#  location   :string(255)
#  rating     :integer
#  department :integer
#  comment    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Recommendation < ActiveRecord::Base
end
