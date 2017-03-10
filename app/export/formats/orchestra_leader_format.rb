module Formats
  class OrchestraLeaderFormat
    def initialize
      @total = {
          :dormitory => 0,
          :medal => 0,
          :tag => 0,
          :tshirt => 0,
          :total_cost => 0,
          :ticket => {
              :thursday => 0,
              :friday => 0,
              :saturday => 0
          },
          :food_ticket => {
              :thursday => 0,
              :friday => 0,
              :saturday => 0
          }
      }
    end

    def column_names
      {
          :name => 'Namn',
          :email => 'E-mail',
          :orchestra_ticket => 'Biljett',
          :dormitory => 'Boende',
          :medal => 'Medalj',
          :tag => 'Märke',
          :tshirt => 'T-shirt',
          :orchestra_food_ticket => 'Mat',
          :total_cost => 'Kostnad'
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
          ticket_description_for value.kind
        when :dormitory
          yes_no value
        else
          value
      end
    end

    def value_for(item, column)
      case column
        when :name
          item.user.display_name
        when :email
          item.user.email
        when :medal, :tag, :tshirt
          item_article(item, column)
        else
          item.send(column)
      end
    end

    def extra_row
      [
          'TOTALT',
          '',
          total_ticket_str(@total[:ticket]),
          @total[:dormitory],
          @total[:medal],
          @total[:tag],
          @total[:tshirt],
          total_ticket_str(@total[:food_ticket]),
          @total[:total_cost]
      ]
    end

    private

    def increase_total(column, value)
      if @total.has_key? column
        if value.is_a? Numeric
          @total[column] += value
        elsif value
          @total[column] += 1
        end
      end

      if column == :orchestra_ticket
        increase_ticket_total(@total[:ticket], ticket_count_increase_for(value.kind))
      end

      if column == :orchestra_food_ticket
        increase_ticket_total(@total[:food_ticket], ticket_count_increase_for(value.kind))
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