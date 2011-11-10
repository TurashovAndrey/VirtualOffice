class CompaniesController < ApplicationController

  filter_resource_access

  def show
  end

  def edit
  end

  def update
    if @company.save
      flash[:notice] = t('company.flashes.updated')
      redirect_to company_path
    else
      flash[:error] = t('company.flashes.update_error')
      render 'edit'
    end
  end

  protected

  def load_company
    @company = current_user.company
  end

end
