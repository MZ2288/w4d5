class PostsController < ApplicationController
  before_action :require_author!, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    @subs = Sub.all
    render :new
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    return nil if @post.nil?
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:notice] = @post.errors.full_messages
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    render :show
  end

  def create
    @post = current_user.posts.new(post_params)
    @subs = Sub.all

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:notice] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = ["#{@post.title deleted}."]
    redirect_to sub_url(@post.sub_id)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end

  def require_author!
    post = Post.find(params[:id])
    redirect_to post_url(post) unless current_user.id == post.author_id
  end
end
