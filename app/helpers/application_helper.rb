module ApplicationHelper
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
