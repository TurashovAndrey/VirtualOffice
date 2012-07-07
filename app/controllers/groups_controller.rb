class GroupsController < ApplicationController
  def new
    @group = Group.new
    @group.parent_id = params[:parent_id]
    @group.company = current_user.company

    @groups = Group.where(:company_id => current_user.company.id).where(:parent_id => nil)
  end

  def create
    @group = Group.new
    @group.company = current_user.company
    @group.update_attributes(params[:group])
  end

  def show
    @group = Group.find(params[:id])
    @groups = Group.where(:company_id => current_user.company.id).where(:parent_id => nil)
    @tasks = Permission.where(:company_id => current_user.company).where(:group_id => @group).where(:task_id => !nil )
  end
end
