class AdminController < ApplicationController
  before_filter :basic
  def recommendations
    @department_strings = %w(なし 内科 歯科 眼科 耳鼻科 皮膚科 形成外科 整形外科 泌尿器科 小児科 産婦人科 精神科)
    @recommendations = Recommendation.all
    render layout: false
  end
  private
    def basic
      authenticate_or_request_with_http_basic do |user, pass|
        user == ENV["BASIC_USER"] && pass == ENV["BASIC_PASS"]
      end
    end
end
