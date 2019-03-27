module Formats
  class OrchestraLeaderFormat
    def initialize
      @total = {
          :dormitory => 0,
          :tshirt => 0,
          :shirt_size => {
            :ds => 0,
            :dm => 0,
            :dl => 0,
            :dxl => 0,
            :dxxl => 0 ,
            :hs => 0,
            :hm => 0,
            :hl => 0,
            :hxl => 0,
            :hxxl => 0 ,
            :notchosen => 0 ,
          },
          :medal => 0,
          :tag => 0,
          :total_cost => 0,
          :is_late_registration => 0,
          :instrument_size =>{
            :very_small => 0,
            :small => 0,
            :medium => 0,
            :large => 0,
            :none => 0,
          },
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
          :name => 'Namn',
          :email => 'E-mail',
          :instrument_size => 'Instrument/utrustningsstorlek',
          :orchestra_ticket => 'Biljett',
          :dormitory => 'Boende',
          :tshirt => 'T-shirt',
          :shirt_size => 'Tröjstorlek',
          :medal => 'Medalj',
          :tag => 'Märke',
          :orchestra_food_ticket => 'Mat',
          :is_late_registration => 'Sen anmälan',
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
          if value.nil?
            ticket_description_for 5
          else
            ticket_description_for value.kind
          end
        when :instrument_size
          instrument_size_description_for value
        when :shirt_size
          if value.size.nil?
            shirt_size_description_for 10
          else
            shirt_size_description_for value.size
          end
        when :dormitory, :is_late_registration
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
        when :tshirt, :medal, :tag
          item_article(item, column)
        when :instrument_size
          instrument_size(item, column)
        when :shirt_size
          item_shirt(item)
        else
          item.send(column)
      end
    end

    def extra_row
      column_names.keys.map { |col| total_value_for(col) }
    end

    private

    def increase_total(column, value)
      if value.nil?
        return
      end
      if @total.has_key? column
        if column == :instrument_size
          p instrument_size_increase_for(value)
          increase_total_fields(@total[column], instrument_size_increase_for(value))
        elsif value.is_a? Numeric
          @total[column] += value
        elsif column == :shirt_size
          if value.size.nil?
            increase_total_fields(@total[column], shirt_size_count_increase_for(10, value.data))
          else
            increase_total_fields(@total[column], shirt_size_count_increase_for(value.size, value.data))
          end
        elsif value.is_a? ApplicationRecord
          increase_total_fields(@total[column], ticket_count_increase_for(value.kind))
        elsif value
          @total[column] += 1
        end
      end
    end

    def increase_total_fields(total_field, increments)
      increments.each { |k,v| total_field[k] += v }
    end

    def total_value_for(col)
      case col
        when :name
          'TOTALT'
        when :orchestra_ticket, :orchestra_food_ticket
          total_ticket_str @total[col]
        when :instrument_size
          total_sizes_str @total[col]
        when :shirt_size
          total_size_str @total[col]
        else
          @total[col]
      end
    end

    def item_article(item, article_name)
      if item.orchestra_articles.nil? || item.orchestra_articles.empty?
        return 
      end
      item.orchestra_articles.where(kind: article_kind_map[article_name]).first.data
    end

    def instrument_size(item, article_name)
      if item.instrument_size.nil? 
        item.user.orchestra_signup.first.instrument_size
      else
        item.instrument_size
      end
    end

    def item_ticket(item, ticket_type)
      ticket_description_for item.send(ticket_type).kind
    end

    def item_shirt(item)
      item.orchestra_articles.where(kind: 0).first
    end

    def article_kind_map
      {
          :tshirt => 0,
          :medal => 1,
          :tag => 2
      }
    end

    def ticket_description_for(kind)
      descriptions = {
          0 => 'Torsdag, Fredag, Lördag',
          1 => 'Fredag, Lördag',
          2 => 'Lördag',
          3 => '',
          4 => 'Torsdag, Fredag',
          5 => 'Ingen biljett (anmälan via annan orkester)'
      }

      descriptions[kind]
    end

    def shirt_size_description_for(size)
      if size.is_a? String
        size = size.to_i
      end
      descriptions = {
          0 => 'Dam S',
          1 => 'Dam M',
          2 => 'Dam L',
          3 => 'Dam XL',
          4 => 'Dam XXL',
          5 => 'Herr S',
          6 => 'Herr M',
          7 => 'Herr L',
          8 => 'Herr XL',
          9 => 'Herr XXL',
          10 => 'Ej valt'
      }

      descriptions[size]
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
          5 => {},
      }
      increments[kind]
    end

    def instrument_size_description_for(kind)
      descriptions = {
          0 => 'Mycket litet',
          1 => 'Litet',
          2 => 'Medel',
          3 => 'Stort',
          4 => 'Inget',
      }

      descriptions[kind]
    end

    def instrument_size_increase_for(kind)
      increments = {
        0 => { :very_small => 1 },
        1 => { :small => 1 },
        2 => { :medium => 1 },
        3 => { :large => 1},
        4 => {}
      }

      increments[kind]
    end

    def shirt_size_count_increase_for(size, amt)
      if size.is_a? String
        size = size.to_i
      end
      increments = {
          0 => {
              :ds => amt
          },
          1 => {
              :dm => amt
          },
          2 => {
              :dl => amt
          },
          3 => {
              :dxl => amt
          },
          4 => {
              :dxxl => amt
          },
          5 => {
              :hs => amt
          },
          6 => {
              :hm => amt
          },
          7 => {
              :hl => amt
          },
          8 => {
              :hxl => amt
          },
          9 => {
              :hxxl => amt
          },
          10 => {
              :notchosen => amt
          },
      }

      increments[size]
    end

    def yes_no(value)
      value ? 'Ja' : 'Nej'
    end

    def total_ticket_str(total_field)
      "Torsdag: #{total_field[:thursday]}, Fredag: #{total_field[:friday]}, Lördag: #{total_field[:saturday]}"
    end

    def total_sizes_str(total_field)
      "M-Litet: #{total_field[:very_small]}, Litet: #{total_field[:small]}, Medel: #{total_field[:medium]}, Stort: #{total_field[:large]}"
    end

    def total_size_str(total_field)
      "Dam S: #{total_field[:ds]}, Dam M: #{total_field[:dm]}, Dam L: #{total_field[:dl]}, Dam XL #{total_field[:dxl]}, Dam XL #{total_field[:dxxl]},
Herr S: #{total_field[:hs]}, Herr M: #{total_field[:hm]}, Herr L: #{total_field[:hl]}, Herr XL #{total_field[:hxl]}, Herr XL #{total_field[:hxxl]}, Ej valt: #{total_field[:notchosen]}"
    end
  end
end
