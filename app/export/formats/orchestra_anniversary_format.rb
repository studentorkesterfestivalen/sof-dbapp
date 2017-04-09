module Formats
  class OrchestraAnniversaryFormat
    def column_names
      {
          :user_id => 'Orkestermedlem',
          :orchestra_id => 'Orkester',
          :email => 'Mailadress',
          :consecutive_10 => '10 år i rad',
          :attended_25 => '25e året'
      }
    end

    def data_for(item, column)
      value_for(item, column)
    end

    def value_for(item, column)
      case column
        when :orchestra_id
          Orchestra.where(id: item.send(column)).pluck(:name).first
        when :user_id
          User.where(id: item.user_id).pluck(:display_name).first
        when :email
          User.where(id: item.user_id).pluck(:email).first
        else
          yes_no(item.send(column))
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