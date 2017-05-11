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
      OrderItem.joins(product: [:base_product], order: []).where(created_at: date.midnight..date.end_of_day).group('base_products.name', "strftime('%Y-%m-%d %H:00', order_items.created_at)", 'products.kind')
    else
      OrderItem.joins(product: [:base_product], order: []).group('base_products.name', 'DATE(order_items.created_at)', 'products.kind')
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
      params[:date].to_date.midnight
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
      Array.new(24) { |x| (first_label + x.hours).strftime('%H:%M') }
    else
      first_label.upto(last_label)
    end
  end

  def label(k)
    [k[0], k[2]]
  end

  def value_index(k)
    if params[:date].present?
      (k[1].to_datetime.hour).to_i
    else
      (k[1].to_date - first_label).to_i
    end
  end
end
