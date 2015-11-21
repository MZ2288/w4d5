class SubsController < ApplicationController
  before_action :require_moderator!, only: [:edit, :update, :destroy]

  def index
    @subs = Sub.all
    render :index
  end

  def show
    @sub = Sub.includes(:posts).find(params[:id])
    @posts = @sub.posts
    
    render :show
  end

  def new
    @sub = Sub.new
    render :new
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def create
    @sub = current_user.subs.new(sub_params)

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:notice] = @sub.errors.full_messages
      render :new
    end
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:notice] = @sub.error.full_messages
      render :edit
    end
  end

  def destroy
    @sub = Sub.find(params[:id])
    @sub.destroy
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_moderator!
    mod_id = Sub.find(params[:id]).moderator_id
    redirect_to subs_url unless current_user.id == mod_id
  end
end
