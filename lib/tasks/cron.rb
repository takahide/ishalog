require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'kconv'

class Cron
  def self.canonicalize_departments
    Clinic.find_each do |c|
      canons = []
      departments = c.department.split(",")
      departments.each do |d|
        department = Department.find_by(name: d)
        canons.push department.canon
      end
      canons.uniq!
      c.canon = canons.join(",")
      c.save
    end

    candidates = []
    Department.find_each do |d|
      candidates.push d.canon
    end
    candidates.uniq!
    File.open("public/canon_departments.txt", "w") do |file|
      file.puts candidates.join(",")
    end
  end

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
      if all % 15 == 0
        page_number = ((all - (all % 15)) / 15)
      else
        page_number = ((all - (all % 15)) / 15) + 1
      end
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
          clinic.url = c.css(".clinic_url a").attr("href").content.strip if c.css(".clinic_url a").present? && c.css(".clinic_url a").attr("href").content.strip.length <= 255
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

  def self.get_stations
    pages = [
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%82",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%84",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%86-%E3%81%88",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%8A",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%8B",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%8D",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%8F-%E3%81%91",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%93",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%95",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%97-%E3%81%97%E3%82%82",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%97%E3%82%84-%E3%81%97%E3%82%93",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%99-%E3%81%9D",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%9F",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%A1-%E3%81%A6",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%A8",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%AA",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%AB",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%AC-%E3%81%AE",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%AF",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%B2",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%B5-%E3%81%BB",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%BE",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%81%BF",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%82%80-%E3%82%82",
      "https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%89%84%E9%81%93%E9%A7%85%E4%B8%80%E8%A6%A7_%E3%82%84-%E3%82%8F%E8%A1%8C"
    ]

    pages.each do |p|
      page = ssl_access(p).to_s
      html = Nokogiri::HTML(page, nil, 'utf-8')
      lis = html.css("h4 + ul li")
      lis.each do |l|
        station = Station.new
        station.raw = l.text
        name = l.css("a").text
        name.gsub!(/駅$/, "")
        name.gsub!(/駅 \(/, " (")
        station.name = name
        station.save
      end

      lis = html.css("h3 + ul li")
      lis.each do |l|
        unless l.text == "アカウント作成" || l.text == "ログイン" || l.text == "ページ" || l.text == "ノート" || l.text == "閲覧" || l.text == "編集" || l.text == "履歴表示" 
          station = Station.new
          station.raw = l.text
          name = l.css("a").text
          name.gsub!(/駅$/, "")
          name.gsub!(/駅 \(/, " (")
          station.name = name
          station.save
        end
      end
    end

    Station.find_each do |s|
      a = s.raw.split("（")[1] if s.raw.split("（").size > 1
      if a.nil?
        hiragana = s.name
      else
        b = a.split("）")[0]
        hiragana = b.split("・")[0]
      end
      hiragana.gsub!(/えき$/, "")
      s.hiragana = hiragana
      s.save
    end
  end

  def self.retrieve_departments
    Clinic.find_each do |c|
      departments = c.department.split(",")
      departments.each do |d|
        Department.where(name: d.strip).first_or_create
      end
    end
  end

  def self.access url, sec=5
    sleep(rand(20) + sec)
    method_name = caller[0][/`([^']*)'/, 1]
    logger = Logger.new "log/runner/#{method_name.split(" ").last}.log"
    logger.debug "Accessing #{url}"
    Nokogiri::HTML(open(url).read.toutf8, nil, 'utf-8')
  end

  def self.ssl_access url, sec=1
    sleep(rand(2) + sec)
    method_name = caller[0][/`([^']*)'/, 1]
    logger = Logger.new "log/runner/#{method_name.split(" ").last}.log"
    logger.debug "Accessing #{url}"
    Nokogiri::HTML(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read.toutf8, nil, 'utf-8')
  end
end
