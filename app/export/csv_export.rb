class CSVExport
  class << self
    def render_csv(data, format_class)
      format = format_class.new
      columns = format.column_names
      CSV.generate do |csv|
        csv << ['sep=,']
        csv << columns.values
        data.each do |item|
          values = columns.keys.map { |col| format.data_for(item, col) }
          if values.all? { |e| !e.nil? }
            csv << values
          end
        end
        extra_row = format.extra_row
        unless extra_row.nil?
          csv << extra_row
        end
      end
    end
  end
end
