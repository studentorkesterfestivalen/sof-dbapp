module Formats
  class OrchestraAllergiesFormat
    def initialize
      @total = {
          :vegetarian => 0,
          :vegan => 0,
          :lactos => 0,
          :gluten => 0,
          :shellfish => 0,
          :fish => 0,
          :peanuts => 0,
          :other => 0
      }
    end

    def column_names
      {
          :orchestra_id => 'Orkester',
          :user_id => 'Namn',
          :vegetarian => 'Vegetarian',
          :vegan => 'Vegan',
          :lactos => 'Laktos',
          :gluten => 'Gluten',
          :shellfish => 'Skaldjur',
          :fish => 'Fisk',
          :peanuts => 'Jordnötter',
          :other => 'Special'
      }
    end

    def data_for(item, column)
      value = value_for(item, column)
      increase_total(column, value)
      format_value(column, value)
    end

    def value_for(item, column)


      case column
        when :orchestra_id
          Orchestra.where(id: item.orchestra_id).pluck(:name).first
        when :user_id
          User.where(id: item.user_id).pluck(:display_name).first
        else
          get_allergy(item, column)
      end
    end

    def extra_row
      column_names.keys.map { |col| total_value_for(col) }
    end

    private

    def get_allergy(item, column)
      allergies = item.special_diets.name
      vegetarian = allergies.slice! 'Vegetarian'
      vegan = allergies.slice! 'Vegan'
      lactos = allergies.slice! 'Laktos'
      gluten = allergies.slice! 'Gluten'
      shellfish = allergies.slice! 'Skaldjur'
      fish = allergies.slice! 'Fisk'
      peanuts = allergies.slice! 'Jordnötter'
      other = allergies

      if column == :vegetarian and vegetarian
        'x'
      elsif column == :vegan and vegan
        'x'
      elsif column == :lactos and lactos
        'x'
      elsif column == :gluten and gluten
        'x'
      elsif column == :shellfish and shellfish
        'x'
      end

    end

  end
end