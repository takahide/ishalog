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
  def close_clinics
    station = self.station
    id = self.id
    main_department = self.department.split(",")[0]
    prefecture = self.address[0..1]

    Clinic.where(station: station).where("address LIKE ?", "#{prefecture}%").where("department LIKE ?", "%#{main_department}%").where("id != ?", id)
  end
end
