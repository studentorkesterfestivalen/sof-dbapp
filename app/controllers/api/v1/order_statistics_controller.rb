class API::V1::OrderStatisticsController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  FIRST_DATE = '2017-04-23'.to_date
  LAST_DATE = '2017-05-14'.to_date

  def summary
    require_admin_permission AdminPermission::ANALYST

    if params[:parameter].present?
      # Display data from the first day of ticket sale until the last, or today
      date_from = FIRST_DATE
      date_to = [LAST_DATE, Date.today].min

      num_days = (date_to - date_from).to_i + 1
      labels = date_from.upto(date_to)
      value_map = {}

      # Query database for requested parameter
      query_result = evaluate_parameter(params[:parameter].to_sym)

      # Prepare value_map with zeroes for all labels and fill with available data
      query_result.each { |k, v| value_map[[k[0], k[2]]] = [0] * num_days }
      query_result.each { |k, v| value_map[[k[0], k[2]]][(k[1].to_date - date_from).to_i] = v }

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
    OrderItem.joins(product: [:base_product], order: []).group('base_products.name', 'DATE(order_items.created_at)', 'products.kind')
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

    if kind.nil? or kind.empty?
      name
    else
      "#{name} (#{kind})"
    end
  end
end
