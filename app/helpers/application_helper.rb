module ApplicationHelper
  def default_meta_tags
    {
      site: '',
      separator: '|',
      title: 'ISHALAN（イシャラン） - 友達の口コミで探せる、無料の病院検索サービス',
      description: ' オススメの病院を探している人のための病院検索サイト「ISHALAN（イシャラン)」全国にある病院177,769件の病院情報をまとめて掲載中。ユーザーのおすすめや口コミをもとに、様々なジャンルの信頼できる病院を科目や最寄り駅から見つけることができます！',
      charset: 'utf-8',
    }
  end
  def header
    render "shared/header"
  end

  def footer
    render "shared/footer"
  end

  def search results
    @results = results
    render "shared/search"
  end
end
