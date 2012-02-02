class CompaniesController < ApplicationController

  filter_resource_access

  def show
  end

  def edit
  end

  def update
    @company.update_attribute(:name,params[:company][:name])
    @company.update_attribute(:url_base,params[:company][:url_base])
    @company.update_attribute(:logo, params[:company][:logo])

    if @company.save
      flash[:notice] = t('company.flashes.updated')
      redirect_to company_path
    else
      flash[:error] = t('company.flashes.update_error')
      redirect_to company_path
    end
  end

  protected

  def load_company
    @company = current_user.company
  end

end
