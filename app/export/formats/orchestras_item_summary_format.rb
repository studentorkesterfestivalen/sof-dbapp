module Formats
  class OrchestrasItemSummaryFormat
    def initialize
      @total = {
          :dormitory => 0,
          :medal => 0,
          :tag => 0,
          :tshirt => 0,
          :is_late_registration => 0,
          :orchestra_ticket => {
              :thursday => 0,
              :friday => 0,
              :saturday => 0
          },
          :orchestra_food_ticket => {
              :thursday => 0,
              :friday => 0,
              :saturday => 0
          }
      }
    end

    def column_names
      {
          :name => 'Orkester',
          :dormitory => 'Sovsal',
          :medal => 'Medaljer',
          :tag => 'Märken',
          :tshirt => 'T-shirt',
          :orchestra_food_ticket => 'Matbiljetter',
          :is_late_registration => 'Sen anmälan',
      }
    end

    def data_for(item, column)
      value = value_for(item, column)
      increase_total(column, value)
      format_value(column, value)
    end

    def format_value(column, value)
      case column
        when :orchestra_ticket, :orchestra_food_ticket
          total_ticket_str(value)
        else
          value
      end
    end

    def value_for(item, column)
      case column
        when :name
          item.send(column)
        else
          value_for_item(item, column)
      end
    end

    def value_for_item(item, column)
      if column == :orchestra_ticket || column == :orchestra_food_ticket
        value = {
            :thursday => 0,
            :friday => 0,
            :saturday => 0
        }
      else
        value = 0
      end

      item.orchestra_signups.each do |signup|
        case column
          when :dormitory, :is_late_registration
            value += 1 if signup.send(column)
          when :medal, :tag, :tshirt
            value += item_article(signup, column)
          when :orchestra_food_ticket, :orchestra_ticket
            increase_ticket_total(value, ticket_count_increase_for(signup.send(column).kind))
          else
            value += signup.send(column)
        end
      end
      value
    end

    def extra_row
      column_names.keys.map { |col| total_value_for(col) }
    end

    private

    def increase_total(column, value)
      puts "Value: #{value}"
      if @total.has_key? column
        if value.is_a? Numeric
          @total[column] += value
        elsif value.is_a? Hash
          increase_ticket_total(@total[column], value)
        elsif value
          @total[column] += 1
        end
      end
    end

    def total_value_for(col)
      case col
        when :name
          'TOTALT'
        when :orchestra_ticket, :orchestra_food_ticket
          total_ticket_str @total[col]
        else
          @total[col]
      end
    end

    def increase_ticket_total(total_field, increments)
      increments.each { |k,v| total_field[k] += v }
    end

    def item_article(item, article_name)
      item.orchestra_articles.where(kind: article_kind_map[article_name]).count
    end

    def item_ticket(item, ticket_type)
      ticket_description_for item.send(ticket_type).kind
    end

    def article_kind_map
      {
          :tshirt => 1,
          :medal => 2,
          :tag => 3
      }
    end

    def ticket_description_for(kind)
      descriptions = {
          0 => 'Torsdag, Fredag, Lördag',
          1 => 'Fredag, Lördag',
          2 => 'Lördag',
          3 => '',
          4 => 'Torsdag, Fredag'
      }

      descriptions[kind]
    end

    def ticket_count_increase_for(kind)
      increments = {
          0 => {
              :thursday => 1,
              :friday => 1,
              :saturday => 1
          },
          1 => {
              :friday => 1,
              :saturday => 1
          },
          2 => {
              :saturday => 1
          },
          3 => {},
          4 => {
              :thursday => 1,
              :friday => 1
          },
      }

      increments[kind]
    end

    def yes_no(value)
      value ? 'Ja' : 'Nej'
    end

    def total_ticket_str(total_field)
      "Torsdag: #{total_field[:thursday]}, Fredag: #{total_field[:friday]}, Lördag: #{total_field[:saturday]}"
    end
  end
end