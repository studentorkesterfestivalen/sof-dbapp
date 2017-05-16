class API::V1::OrderStatisticsController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  FIRST_DATE = '2017-04-23'.to_date
  LAST_DATE = '2017-05-14'.to_date

  def summary
    require_admin_permission AdminPermission::ANALYST

    if params[:parameter].present?
      num_days = labels.count
      value_map = {}

      # Query database for requested parameter
      query_result = evaluate_parameter(params[:parameter].to_sym)

      # Prepare value_map with zeroes for all labels and fill with available data
      query_result.each { |k, v| value_map[label(k)] = [0] * num_days }
      query_result.each { |k, v| value_map[label(k)][value_index(k)] = v }

      # Generate data structure
      data = {
          labels: labels,
          datasets: value_map.map do |product, values|
            {
                name: product_name(product),
                values: values
            }
          end
      }

      # Sum the values over all previous days for every day if requested
      if params[:sum] == 'true'
        sum_days data
      end

      # Append index to dataset which is used for coloring the graph
      data[:datasets].each_with_index { |x, index| x[:index] = index }
    else
      data = {}
    end

    render json: data
  end

  def key_measures
    rebate_counts = count_rebates
    data = {
        used_lintek_rebate: Order.sum(:rebate),
        used_funkis_rebate: Order.sum(:funkis_rebate),
        collected: OrderItem.where(collected: true).count,
        collectable: OrderItem.where(collected: false).count
    }
    data = data.merge(rebate_counts)

    render json: data
  end

  private

  NAMES_ELIGABLE_FOR_REBATE = ['Dagsbiljett', 'Endagsbiljett', 'Helhelgsbiljett', 'Orkesterbiljett']

  def evaluate_parameter(parameter)
    case parameter
      when :full_cost
        base_query.sum(:cost)
      when :sold_count
        base_query.count
      when :rebate_count
        # Count every OrderItem which is eligable for rebate and part of an order where LinTek rebate was given
        base_query.where('base_products.name': NAMES_ELIGABLE_FOR_REBATE).where.not('orders.rebate' => 0).count
      else
        {}
    end
  end

  def base_query
    if params[:date].present?
      date = params[:date].to_date
      OrderItem.joins(product: [:base_product], order: []).where(created_at: first_label..last_label).group('base_products.name', created_at_hour, 'products.kind')
    else
      OrderItem.joins(product: [:base_product], order: []).group('base_products.name', 'DATE(order_items.created_at)', 'products.kind')
    end
  end

  def created_at_hour
    if Rails.env.production?
      "to_char(order_items.created_at, 'YYYY-mm-dd HH24:00')"
    else
      "strftime('%Y-%m-%d %H:00', order_items.created_at)"
    end
  end

  def sum_days(data)
    data[:datasets].each do |dataset|
      sum = 0
      dataset[:values].each_with_index do |value, index|
        sum += value
        dataset[:values][index] = sum
      end
    end
  end

  def product_name(product)
    name = product[0]
    kind = product[1]

    if kind.blank?
      name
    else
      "#{name} (#{kind})"
    end
  end

  def first_label
    if params[:date].present?
      params[:date].to_date.midnight + timezone_offset
    else
      FIRST_DATE
    end
  end

  def last_label
    if params[:date].present?
      first_label + 23.hours
    else
      # Display data until the last day, or today
      [LAST_DATE, Date.today].min
    end
  end

  def labels
    if params[:date].present?
      Array.new(24) { |x| "#{x.to_s.rjust(2, '0')}:00" }
    else
      first_label.upto(last_label)
    end
  end

  def label(k)
    [k[0], k[2]]
  end

  def value_index(k)
    if params[:date].present?
      ((k[1].to_datetime + timezone_offset).hour).to_i
    else
      (k[1].to_date - first_label).to_i
    end
  end

  def timezone_offset
    params[:date].to_date.in_time_zone('Stockholm').utc_offset.seconds
  end

  def count_rebates
    @counts = {
        :thursday => 0,
        :friday => 0,
        :saturday => 0,
        :weekend => 0,
        :unknown => 0
    }
    # Product id: 3 = Thursday
    # Product id: 4 = Friday
    # Product id: 5 = Satyrday
    # BaseProduct id: 4 = Weekend
    Order.find_each do |order|
      @cur_rebate = order.rebate
      if @cur_rebate > 0
        # Find the easy ones, thursdays and weekends
        order.order_items.each do |item|
          if item.product_id == 2 and @cur_rebate - 20 >= 0
            @cur_rebate -= 20
            @counts[:thursday] += 1
          elsif item.product.base_product.id == 4 and @cur_rebate - 90 >= 0
            @cur_rebate -= 90
            @counts[:weekend] += 1
          end
        end

        # Find all the orders with only one friday or saturday
        if order.order_items.count == 1 and @cur_rebate - 30 >= 0
          if order.order_items.first.product_id == 4
            @cur_rebate -= 30
            @counts[:friday] += 1
          elsif order.order_items.first.product_id == 5
            @cur_rebate -= 30
            @counts[:saturday] += 1
          end
        end

        # Find those order that used either a friday or saturday rebate and only that rebate
        if @cur_rebate == 30
          if order.order_items.any? { |a| a.product_id == 4 }
            @cur_rebate -= 30
            @counts[:friday] += 1
          elsif order.order_items.any? { |a| a.product_id == 5 }
            @cur_rebate -= 30
            @counts[:saturday] += 1
          end
        end

        if @cur_rebate >= 30
          unknown = @cur_rebate / 30
          @counts[:unknown] += unknown
        end
      end
    end

    @counts
  end
end
