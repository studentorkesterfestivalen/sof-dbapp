class API::V1::OrderStatisticsController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  PARAMETERS = [
      :full_cost,
      :sold_count,
      :rebate_count
  ]

  def summary
    require_admin_permission AdminPermission::ANALYST

    date_from = params[:from].to_date
    date_to = params[:to].to_date

    data = {
        labels: []
    }

    date_from.upto(date_to) do |date|
      data[:labels] << date

      # Generate summaries for the requested date or date span
      local_date_from = params[:sum].present? ? date_from : date
      item_summaries = Product.all.map { |x| summary_for_item(x, local_date_from, date) }

      if data[:datasets].nil?
        # Create initial structure in dataset
        item_summaries.each do |item|
          PARAMETERS.each { |x| item[x] = [item[x]] }
        end
        data[:datasets] = item_summaries.map { |x| [x[:id], x] }.to_h
      else
        # Append dataset structure with more data
        item_summaries.each do |item|
          base = data[:datasets][item[:id]]
          PARAMETERS.each { |x| base[x] << item[x] }
        end
      end
    end

    render json: data
  end

  private

  def summary_for_item(product, from, to)
    summary_hash = {
        id: product.id,
        name: product_name(product)
    }

    PARAMETERS.each { |x| summary_hash[x] = evaluate_parameter(product, x, from, to) }

    summary_hash
  end

  ELIGABLE_NAMES = ['Dagsbiljett', 'Endagsbiljett', 'Helhelgsbiljett', 'Orkesterbiljett']
  def is_eligable_for_rebate?(product)
    ELIGABLE_NAMES.include? product.base_product.name
  end

  def evaluate_parameter(product, parameter, from, to)
    query = base_query(product, from, to)
    case parameter
      when :full_cost
        query.sum { |x| x.cost }
      when :sold_count
        query.count
      when :rebate_count
        if is_eligable_for_rebate?(product)
          query.where.not('orders.rebate' => 0).count
        else
          0
        end
      else
        0
    end
  end

  def base_query(product, from, to)
    OrderItem.includes(:order).where(product_id: product.id).where(created_at: from.midnight..to.end_of_day)
  end

  def product_name(product)
    if product.kind.nil? or product.kind.empty?
      product.base_product.name
    else
      "#{product.base_product.name} (#{product.kind})"
    end
  end
end
