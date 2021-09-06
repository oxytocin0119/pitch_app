class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "アカウントが作成されました"
      redirect_to @user
    else
      render 'new'
    end
  end

  def create_by_twitter
    unless request.env['omniauth.auth'][:uid]
      flash[:danger] = '連携に失敗しました'
      redirect_to root_path
    end
    user_data = request.env['omniauth.auth']
    @user = User.find_by(twitter_id: user_data[:info][:nickname])

    if @user
#      log_in user
      flash[:success] = 'ログインしました'
      redirect_to @user
    else
      @user = User.new(
        name: user_data[:info][:name],
        twitter_id: user_data[:info][:nickname],
        icon: user_data[:info][:image],
      )
=begin
      if @user.save
#        log_in new_user
        flash[:success] = 'アカウントが作成されました'
        redirect_to @user
      else
        flash[:danger] = '予期せぬエラーが発生しました'
        render 'new'
      end
=end
      render 'new'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :twitter_id,
                                          :password, :password_confirmation,
                                          :icon)
    end
end
