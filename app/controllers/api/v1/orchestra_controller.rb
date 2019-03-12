class API::V1::OrchestraController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN

    render :json => Orchestra.all, methods: :members_count
  end

  def create
    unless current_user.has_admin_permission? AdminPermission::ORCHESTRA_ADMIN
      raise 'Cannot create orchestra'
    end

    orchestra = Orchestra.new(item_params)
    orchestra.user = current_user
    orchestra.user.usergroup |= UserGroupPermission::ORCHESTRA_LEADER | UserGroupPermission::ORCHESTRA_MEMBER
    orchestra.save!
    orchestra.user.save!

    OrchestraMailer.orchestra_invitation(orchestra).deliver_later

    render :json => orchestra
    # redirect_to api_v1_orchestra_url(orchestra)
  end

  def show
    orchestra = Orchestra.find(params[:id])
    require_ownership_or_admin_permission orchestra, AdminPermission::ORCHESTRA_ADMIN

    render :json => orchestra, include: [orchestra_signups: {include: [:user], methods: :total_cost}], methods: :members_count
  end

  def all_signups
    orchestra = Orchestra.find(params[:id])
    require_ownership_or_admin_permission orchestra, AdminPermission::ORCHESTRA_ADMIN

    render :plain => CSVExport.render_csv(orchestra.orchestra_signups, Formats::OrchestraLeaderFormat)
  end

  def item_summary
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN

    orchestras = Orchestra.all
    render :plain => CSVExport.render_csv(orchestras, Formats::OrchestrasItemSummaryFormat)
  end

  def extra_performances
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN

    orchestra_signups = OrchestraSignup.where.not(other_performances: ['', nil]).order(:orchestra_id)
    render :plain => CSVExport.render_csv(orchestra_signups, Formats::OrchestraPerformanceFormat)
  end

  def anniversary
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN

    orchestra_signups = OrchestraSignup.where.not(consecutive_10: [false, nil]).or(OrchestraSignup.where.not(attended_25: [false, nil])).order(:orchestra_id)
    render :plain => CSVExport.render_csv(orchestra_signups, Formats::OrchestraAnniversaryFormat)
  end

  def allergies
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN

    orchestra_signups = OrchestraSignup.order(:orchestra_id).includes(:special_diets).where.not(:special_diets => {id: nil})
    render :plain => CSVExport.render_csv(orchestra_signups, Formats::OrchestraAllergiesFormat)
  end

  def lintek_rebate
    require_admin_permission AdminPermission::ORCHESTRA_ADMIN

    orchestra_signups = User.includes(:orchestra_signup).where.not('orchestra_signups.id' => nil).where(union: 'LinTek')
    render :plain => CSVExport.render_csv(orchestra_signups, Formats::OrchestraLintekRebateFormat)

  end

  def update
    orchestra = Orchestra.find(params[:id])
    require_ownership orchestra

    unless params[:item][:code].nil?
      # Don't allow setting a custom access code as it may be insecure
      orchestra.generate_new_access_code
      unless orchestra.save!
        raise 'Unable to generate new access code'
      end
    end

    if orchestra.update(item_params)
      redirect_to api_v1_orchestra_url(orchestra)
    else
      raise 'Unable to save orchestra'
    end
  end

  def destroy
    orchestra = Orchestra.find(params[:id])
    require_ownership orchestra

    orchestra.destroy

    head :no_content
  end

  private

  def item_params
    params.require(:data).permit(
        :name,
        :email,
        :orchestra_type,
        :allow_signup,
        :dormitory,
        :arrival_date
    )
  end
end
