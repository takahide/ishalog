require 'nokogiri'
require 'open-uri'
require 'kconv'

class Cron
  def self.get_hospital_pages
    prefecture = "tokyo"
    max = 1894
    for page in 1..max
      p = HospitalPage.new
      p.prefecture = prefecture
      p.page = page
      p.html = access("http://byoinnavi.jp/#{prefecture}?p=#{page}").to_s
      p.save
    end
  end

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

  def self.access url, sec=1
    sleep(rand(12) + sec)
    method_name = caller[0][/`([^']*)'/, 1]
    logger = Logger.new "log/runner/#{method_name.split(" ").last}.log"
    logger.debug "Accessing #{url}"
    Nokogiri::HTML(open(url).read.toutf8, nil, 'utf-8')
  end
end
