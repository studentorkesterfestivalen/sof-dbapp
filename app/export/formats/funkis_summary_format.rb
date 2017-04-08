module Formats
  class FunkisSummaryFormat
    def column_names
      {
          :name => 'Kategori',
          :funkis_name => 'Funkisnamn',
          :points => 'Poäng',
          :date => 'Datum',
          :day => 'Dag',
          :time => 'Tid',
          :red_limit => 'Röd gräns',
          :yellow_limit => 'Gul gräns',
          :green_limit => 'Grön gräns',
          :applicants => 'Anmälda Funkisar',
      }
    end

    def data_for(item, column)
      value_for(item, column)
    end

    def value_for(item, column)
      case column
        when :name
          item.funkis_category.name
        when :funkis_name
          item.funkis_category.funkis_name
        when :applicants
          'temp'
        else
          item.send(column)
      end
    end

    def yes_no(value)
      value ? 'Ja' : 'Nej'
    end

    def extra_row
      nil
    end
  end
end