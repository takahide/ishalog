require 'nokogiri'
require 'open-uri'
require 'kconv'

class Cron
  def self.get_hospital_pages
    Prefecture.find_each do |pref|
      prefecture = pref.url
      max = pref.page_number
      for page in 1..max
        p = HospitalPage.new
        p.prefecture = prefecture
        p.page = page
        p.html = access("http://byoinnavi.jp/#{prefecture}?p=#{page}").to_s
        p.save
      end
    end
  end

  def self.get_prefectures
    page = access("http://byoinnavi.jp").to_s
    html = Nokogiri::HTML(page, nil, 'utf-8')
    prefectures = html.css(".top_area_prefs_left a") + html.css(".top_area_prefs_right a")
    prefectures.each do |p|
      name = p.text.strip
      url =  p.attr("href").split("/").last
      pref = Prefecture.new
      pref.name = name
      pref.url = url
      pref.save
    end
  end

  def self.get_page_numbers
    Prefecture.find_each do |p|
      page = access("http://byoinnavi.jp/#{p.url}").to_s
      html = Nokogiri::HTML(page, nil, 'utf-8')
      all = html.css("#left_main h2 strong.key").first.text.delete(",").delete("件").to_i
      page_number = ((all - (all % 15)) / 15) + 1
      p.page_number = page_number
      p.save
    end
  end

  def self.hospital_pages_to_doctors
    HospitalPage.find_each do |p|
      next if p.html.nil?
      html = Nokogiri::HTML(p.html, nil, 'utf-8')
      clinics = html.css("table.corp_table tr.clinic") #薬局はtr.pharmなので除外される
      clinics.each do |c|
        name = c.css("h3.clinic_name").text.strip.gsub(/(\n)/," ") if c.css("h3.clinic_name").present?
        address = c.css(".clinic_address").text.strip.gsub(/(\n)/," ").gsub(/(\[.*\])/, "").gsub(/\s\s/, " ").strip if c.css(".clinic_address").present?
        Clinic.where(name: name, address: address).first_or_create do |clinic|
          clinic.department = c.css(".clinic_cate").text.strip if c.css(".clinic_cate").present?
          station_info = c.css(".clinic_rail_station").text.strip.gsub(/(\n)/," ").split("(") if c.css(".clinic_rail_station").present?
          if station_info.present?
            clinic.station = station_info[0].strip 
            clinic.distance = station_info[1].split(")")[0].strip if station_info.size >= 2
          end
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

  def self.access url, sec=15
    sleep(rand(10) + sec)
    method_name = caller[0][/`([^']*)'/, 1]
    logger = Logger.new "log/runner/#{method_name.split(" ").last}.log"
    logger.debug "Accessing #{url}"
    Nokogiri::HTML(open(url).read.toutf8, nil, 'utf-8')
  end
end
