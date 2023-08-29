module ApplicationHelper
  include Pagy::Frontend
  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = t("static_pages.full_title")
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end
end
