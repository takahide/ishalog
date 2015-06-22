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
  def department_string
    department_strings = %w(なし 内科 歯科 眼科 耳鼻科 皮膚科 外科 整形外科 泌尿器科 小児科 産婦人科 精神科 総合病院)
    department_strings[self.department]
  end
end
