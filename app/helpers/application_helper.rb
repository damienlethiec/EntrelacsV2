module ApplicationHelper
  include Pagy::Loader

  # Generate pagination series with gaps (e.g., [1, 2, 3, :gap, 8, 9, 10])
  def pagination_series(current_page, total_pages, window: 1)
    return (1..total_pages).to_a if total_pages <= 7

    pages = []

    # Always show first page
    pages << 1

    # Pages around current
    ((current_page - window)..(current_page + window)).each do |p|
      pages << p if p > 1 && p < total_pages
    end

    # Always show last 3 pages
    ((total_pages - 2)..total_pages).each do |p|
      pages << p if p > 1
    end

    pages = pages.uniq.sort

    # Build series with gaps
    series = []
    pages.each_with_index do |page, i|
      series << :gap if i > 0 && page > pages[i - 1] + 1
      series << page
    end

    series
  end

  def nav_link_to(name, path)
    current = current_page?(path)
    classes = if current
      "inline-flex items-center border-b-2 border-tisseurs-teal px-1 pt-1 text-sm font-medium text-gray-900"
    else
      "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
    end

    link_to name, path, class: classes, aria: {current: current ? "page" : nil}
  end

  def mobile_nav_link_to(name, path)
    current = current_page?(path)
    classes = if current
      "block border-l-4 border-tisseurs-teal py-2 pr-4 pl-3 text-base font-medium text-tisseurs-teal"
    else
      "block border-l-4 border-transparent py-2 pr-4 pl-3 text-base font-medium text-gray-600 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-800"
    end

    link_to name, path, class: classes, aria: {current: current ? "page" : nil}
  end
end
