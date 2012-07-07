class DiscussionsController < ApplicationController
  def new
    @themes = Theme.where(:company_id => current_user.company)
    @discussion = Discussion.new
    if !params[:theme_id].nil?
      @discussion.theme = Theme.find(params[:theme_id])
    end
  end

  def create
    @discussion = Discussion.new
    @discussion.user = current_user
    @discussion.company = current_user.company
    @discussion.update_attributes(params[:discussion])
    if !@discussion.theme.nil?
      redirect_to theme_path(@discussion.theme)
    else
      redirect_to themes_path
    end
  end

  def update
      @discussion = Discussion.find(params[:id])
      @discussion.update_attributes(params[:discussion])
      if !((params[:comment][:comment] == "") && (params[:task_attachment].nil?))
        #Save comment and attachment for it
        @comment = Comment.new
        @comment.discussion = @discussion
        @comment.user = current_user
        @comment.company = current_user.company
        @comment.comment = params[:comment][:comment]
        @comment.comment_date = DateTime.now
        @comment.save

        if !(params[:task_attachment].nil?)
          @attachment = TaskAttachment.new
          @attachment.discussion = @discussion
          @attachment.user = current_user
          @attachment.company = current_user.company
          @attachment.comment = @comment
          @attachment.attachment =  params[:task_attachment][:attachment]
          @attachment.save
        end
      end
      redirect_to discussion_path(@discussion)
  end

  def show
    @themes = Theme.where(:company_id => current_user.company)
    @discussion = Discussion.find(params[:id])
    @comment = Comment.new
    @comment.user = current_user
    @task_attachment = TaskAttachment.new
    @comments = Comment.where(:discussion_id => @discussion.id)
  end

end
