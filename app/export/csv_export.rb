class CSVExport
  class << self
    def render_csv(data, format)
      columns = format.column_names
      CSV.generate do |csv|
        csv << columns.values
        data.each do |item|
          values = columns.keys.map { |col| format.data_for(item, col) }
          csv << values
        end
      end
    end
  end
end