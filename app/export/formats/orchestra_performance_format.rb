module Formats
  class OrchestraPerformanceFormat

    def column_names
      {
          :orchestra_id => 'Orkester',
          :user_id => 'Orkestermedlem',
          :other_performances => 'Framför också med'
      }
    end

    def data_for(item, column)
      value_for(item, column)
    end

    def value_for(item, column)
      case column
        when :orchestra_id
          Orchestra.where(id: item.send(column)).pluck('name')[0]
        when :user_id
          User.where(id: item.user_id).pluck('display_name')[0]
        else
          item.send(column)
      end
    end

    def extra_row
      nil
    end
  end
end