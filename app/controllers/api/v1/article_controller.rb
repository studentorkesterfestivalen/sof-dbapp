class API::V1::ArticleController < ApplicationController
  include ViewPermissionConcern

  before_action :authenticate_user!

  def index
    if current_user.has_admin_permission? AdminPermission::MODIFY_ARTICLES
      render :json => AvailableArticle.all
    else
      render :json => AvailableArticle.where(enabled: true)
    end
  end

  def create
    require_admin_permission AdminPermission::MODIFY_ARTICLES

    article = AvailableArticle.new(item_params)
    article.save!

    redirect_to api_v1_article_url(article)
  end

  def show
    article = AvailableArticle.find(params[:id])

    render :json => article
  end

  def update
    require_admin_permission AdminPermission::MODIFY_ARTICLES

    article = AvailableArticle.find(params[:id])
    if article.update(item_params)
      redirect_to api_v1_article_url(article)
    else
      raise 'Unable to save article'
    end
  end

  def destroy
    require_admin_permission AdminPermission::MODIFY_ARTICLES

    if OrchestraArticle.where(kind: params[:id]).any?
      raise 'Unable to remove article with remaining references'
    end

    article = AvailableArticle.find(params[:id])
    article.destroy

    head :no_content
  end

  private

  def item_params
    params.require(:item).permit(
        :name,
        :description,
        :price,
        :data_name,
        :data_description,
        :orchestra_only
    )
  end
end
