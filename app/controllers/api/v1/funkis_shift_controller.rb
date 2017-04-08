class FunkisShiftController < ApplicationController

  def export_applications
    require_permission Permission::LIST_FUNKIS_APPLICATIONS

    funkis_shifts = FunkisShift.all.order(:funkis_category_id).includes(:funkis_category, :funkis_shift_applications)
    render :plain => CSVExport.render_csv(funkis_shifts, Formats::FunkisSummaryFormat)
  end

end
