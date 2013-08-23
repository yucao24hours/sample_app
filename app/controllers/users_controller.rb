class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render "edit"
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    # ユーザを削除する（チェーン）
    User.find(params[:id]).destroy
    # flashにメッセージを入れる
    flash[:success] = "User destroyed."
    # 一覧のURLへリダイレクトする
    redirect_to users_url
  end

  private

    def signed_in_user
      unless signed_in?
        # 未サインインの場合、サインイン後にまたこの場所に戻ってこられるよう、現在の位置を一時保管しておく
        store_location
        # そして、サインインページにリダイレクトさせる（このときflashを使って「Please sign in.」と表示させる
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end