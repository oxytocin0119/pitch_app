class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
#  before_action :admin_user,      only: :destroy
  before_action :current_or_admin, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    update_user = User.find_by(email: @user.email)
    if User.find_by(email: @user.email)\
       && User.find_by(email:@user.email).authenticate(@user.password)\
       && @user.twitter_id #メールアドレスで登録してツイッター連携した場合
      @user.name = User.find_by(email: @user.email).name
      if update_user.update_attributes(twitter_id: @user.twitter_id,
                                       icon:@user.icon,
                                       twitter_uid:@user.twitter_uid)
        log_in update_user
        flash[:success] = "Twitterアカウントを更新しました"
        redirect_to update_user
      else
        flash.now[:danger] = "原因不明のエラー"
        render 'new' and return #なぜか失敗した場合
      end
    elsif @user.twitter_id.present? && update_user.blank? && @user.email.present?
      #登録されていないアドレスに連携させようとした場合
      flash.now[:danger] = "メールアドレスが見つかりませんでした"
      render 'new' and return
    elsif update_user.blank? && @user.save
      if @user.twitter_id.blank? #メールアドレスで登録
        @user.send_activation_email
        flash[:info] = "アカウント有効化のため、登録したメールアドレス宛に送信されたメールをご確認ください"
        redirect_to root_url
      elsif @user.twitter_id.present? #ツイッターで作成した場合
        @user.activate
        log_in @user
        flash[:success] = "アカウントが作成されました"
        redirect_to @user
      end
    else #作成失敗
      if update_user && !(update_user.authenticate(@user.password))
        flash[:danger] = "メールアドレスまたはパスワードが違います"
#      else
 #       flash[:danger] = "原因不明のエラー"
      end
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def change_icon
    @user = User.find(current_user.id)
    if @user.twitter_id && @user.icon
      if @user.update_attributes(icon: nil)
        flash[:success] = '画像をデフォルトにしました'
        redirect_to edit_user_path(@user)
      else
        flash[:danger] = '画像の変更に失敗しました'
        redirect_to edit_user_path(@user)
      end
    else
      if @user.twitter_id
        @user.update_attributes(icon: client.user(@user.twitter_id).profile_image_uri)
        flash[:success] = '画像をTwitterから取得しました'
        redirect_to edit_user_path(@user)
      else
      end
    end
  end

  def destroy
    @user = current_user
    destroy_user = User.find(params[:id])
    if @user.admin? && @user != destroy_user
      destroy_user.destroy
      flash[:success] = "アカウントを消去しました"
      redirect_to users_url
    elsif !(@user.admin?) && @user == destroy_user
      destroy_user.destroy
      flash[:success] = "アカウントを消去しました"
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :twitter_id,
                                          :password, :password_confirmation,
                                          :icon)
    end

    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def current_or_admin
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin? || current_user?(@user)
    end

end
