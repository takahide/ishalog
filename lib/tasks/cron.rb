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

  def self.hospital_pages_to_doctors
    HospitalPage.find_each do |p|
      next if p.html.nil?
      html = Nokogiri::HTML(p.html, nil, 'utf-8')
      clinics = html.css("table.corp_table tr.clinic")
      clinics.each do |c|
        name = c.css("h3.clinic_name").text.strip.gsub(/(\n)/," ") if c.css("h3.clinic_name").present?
        address = c.css(".clinic_address").text.strip.gsub(/(\n)/," ").gsub(/(\[.*\])/, "").gsub(/\s\s/, " ").strip if c.css(".clinic_address").present?
        Clinic.where(name: name, address: address).first_or_create do |clinic|
          clinic.department = c.css(".clinic_cate").text.strip if c.css(".clinic_cate").present?
          station_info = c.css(".clinic_rail_station").text.strip.gsub(/(\n)/," ").split("(") if c.css(".clinic_rail_station").present?
          clinic.station = station_info[0].strip if station_info[0].present?
          clinic.distance = station_info[1].split(")")[0].strip if station_info[1].present?
          clinic.tel = c.css(".clinic_tel").text.strip if c.css(".clinic_tel").present?
          clinic.holidays = c.css(".clinic_list_hour_holiday").text.strip.gsub(/(\n)/," ") if c.css(".clinic_list_hour_holiday").present?
          clinic.url = c.css(".clinic_url a").attr("href").content.strip if c.css(".clinic_url a").present?
        end
      end
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
