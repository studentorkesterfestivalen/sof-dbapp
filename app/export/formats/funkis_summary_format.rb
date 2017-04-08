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
          :applicatans => 'Funkisar',
      }
    end

    def data_for(item, column)
      value_for(item, column)
    end

    def value_for(item, column)
      case column
        when :name
          FunkisCategory.where(:name => item.send(column)).pluck('name').first
        when :funkis_name

        when :points

        else
          false
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