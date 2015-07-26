module ApplicationHelper
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
