module Formats
  class OrchestraLintekRebateFormat
    def initialize
      @total = {
          :lintek_rebate => 0
      }
    end

    def column_names
      {
          :orchestra_id => 'Orkester',
          :name => 'Namn',
          :email => 'E-mail',
          :lintek_rebate => 'Lintek rabatt'
      }
    end

    def data_for(item, column)
      value = value_for(item, column)
      increase_total(column, value)
      value
    end

    def value_for(item, column)
      case column
        when :orchestra_id
          item.orchestra.name
        when :name
          item.user.display_name
        when :email
          item.user.email
        when :lintek_rebate
          lintek_rebate(item)
        else
          item.send(column)
      end
    end

    def extra_row
      column_names.keys.map { |col| total_value_for(col) }
    end

    private

    def increase_total(column, value)
      if @total.has_key? column
        if value.is_a? Numeric
          @total[column] += value
        end
      end
    end

    def total_value_for(col)
      case col
        when :name
          'TOTALT'
        else
          @total[col]
      end
    end

    def lintek_rebate(item)
      rebate = [100, 100, 70, 0]
      rebate[item.orchestra_ticket.kind]
    end

  end
end