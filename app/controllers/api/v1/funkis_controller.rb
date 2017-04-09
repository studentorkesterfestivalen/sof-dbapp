class API::V1::FunkisController < ApplicationController

  def index

    # If all shifts are taken for the current limit, raise the limit
    all_shifts = FunkisShift.all
    unless all_shifts.any? { |x| x.available? }
      ActiveFunkisShiftLimit.raise_limit
    end

    render :json => FunkisCategory.all.order(:id), include: {
        funkis_shifts: {
            methods: [:available]
        }
    }
  end

  def create
    raise 'Not implemented'
  end

  def show
    raise 'Not implemented'
  end

  def update
    raise 'Not implemented'
  end

  def delete
    raise 'Not implemented'
  end
end
