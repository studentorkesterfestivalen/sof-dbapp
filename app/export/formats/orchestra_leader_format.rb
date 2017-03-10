module Formats
  class OrchestraLeaderFormat
    class << self
      def column_names
        {
            :name => 'Namn',
            :orchestra_ticket => 'Biljett',
            :dormitory => 'Boende',
            :medal => 'Medalj',
            :tag => 'Märke',
            :tshirt => 'T-shirt',
            :orchestra_food_ticket => 'Mat'
        }
      end

      def data_for(item, column)
        case column
          when :name
            item.user.display_name
          when :medal, :tag, :tshirt
            item_article(item, column)
          when :orchestra_ticket, :orchestra_food_ticket
            item_ticket(item, column)
          when :dormitory
            yes_no item.send(column)
          else
            item.send(column)
        end
      end

      private

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
            3 => ''
        }

        descriptions[kind]
      end

      def yes_no(value)
        value ? 'Ja' : 'Nej'
      end
    end
  end
end