class UserSessionsController < ApplicationController
 
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        flash[:notice] = "Login successful!"
        redirect_back_or_default account_url
      else
        render :action => "new"
      end
    end
  end

  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy

    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
