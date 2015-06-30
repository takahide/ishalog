# == Schema Information
#
# Table name: clinics
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  department :string(255)
#  address    :string(255)
#  station    :string(255)
#  distance   :string(255)
#  tel        :string(255)
#  holidays   :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Clinic < ActiveRecord::Base
end
