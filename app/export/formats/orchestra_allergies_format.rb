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
          :vegetarian => 'Vegetariskt',
          :vegan => 'Vegansk',
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

    def extra_row
      column_names.keys.map { |column| total_value_for(column) }
    end

    private

    def value_for(item, column)
      case column
        when :orchestra_id
          item.orchestra.name
        when :user_id
          item.user.display_name
        when :other
          item.special_diets.select { |diet| not column_names.values.include? diet.name }
        else
          has_allergy(item, column)
      end
    end

    def increase_total(column, value)
      if value.present?
        unless column == :orchestra_id or column == :user_id
            @total[column] += 1
        end
      end
    end

    def format_value(column, value)
      case column
        when :orchestra_id, :user_id
          value
        when :other
          value.map! { |diet| diet.name }
          value.join(', ')
        else
          if value.present?
            'x'
          end
      end
    end

    def total_value_for(column)
      case column
        when :orchestra_id
          'TOTALT'
        when :user_id
          nil
        else
          @total[column]
      end
    end

    def has_allergy(item, column)
      item.special_diets.any? { |diet| diet.name == column_names[column] }
    end
  end
end