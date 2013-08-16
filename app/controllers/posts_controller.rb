class PostsController < ApplicationController
  def new
    @post = Post.new
    @title = "New Post"
  end

	def index
    @posts = Post.all
    @title = "Message Board"
	end

  def show
    @post = Post.find(params[:id])
    @title = "Show Post"
  end

  def update
    @post = Post.find(params[:id])
    if(@post.update(params[:post].permit(:title, :text)))
      redirect_to @post
    else
      render 'edit'
    end
    @title = "Edit Post"
  end

  def edit
    @post = Post.find(params[:id])
    @title = "Edit Post"
  end

  def create
    @post = Post.new(params[:post].permit(:title, :text))
    if @post.save
      redirect_to @post
    else 
      render 'new'
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :text)
    end
end