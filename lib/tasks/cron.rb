require 'open-uri'

class Cron
  def self.pics
    Recommendation.find_each do |r|
      img_url = "https://graph.facebook.com/#{r.uid}/picture"
      file_name = "#{r.uid}.jpg"
      file_path = "app/assets/images/fb_pics/#{file_name}"
      open file_path, 'wb' do |output|
        open img_url do |data|
          output.write data.read
        end
      end
    end
  end
end
