class Post < ActiveRecord::Base
  def body_with_html
    self.body
    .gsub(/(\r\n|\r|\n)/, "<br>")
    .gsub(/(https?:\/\/[a-zA-Z0-9\-_.\/]*)/, '<a href="\1">\1</a>')
  end
  def introduced_clinics
    clinic_ids = self.clinics.split(",")
    Clinic.where("id in (?)", clinic_ids)
  end
end
