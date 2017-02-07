class Page < ApplicationRecord
  def href
    unless page.empty?
      "/#{category}/#{page}"
    else
      "/#{category}"
    end
  end
end
