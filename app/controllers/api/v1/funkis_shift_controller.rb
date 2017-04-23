class API::V1::FunkisShiftController < ApplicationController
  include ViewPermissionConcern

  def export_applications
    require_admin_permission AdminPermission::LIST_FUNKIS_APPLICATIONS

    funkis_shifts = FunkisShift.all.order(:funkis_category_id).includes(:funkis_category, :funkis_shift_applications)
    render :plain => CSVExport.render_csv(funkis_shifts, Formats::FunkisSummaryFormat)
  end

end
