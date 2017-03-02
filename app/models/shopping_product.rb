class ShoppingProduct < ApplicationRecord
  validate :options_is_valid_json

  def options
    raw_options = super
    unless raw_options.blank?
      JSON.parse raw_options
    end
  end

  private

  def options_is_valid_json
    # Will raise exception on invalid json
    options
  end
end
