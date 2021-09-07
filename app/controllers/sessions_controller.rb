class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います'
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
      log_in @user
      flash[:success] = 'ログインしました'
      redirect_to @user
    else
      @user = User.new(
        name: user_data[:info][:name],
        twitter_id: user_data[:info][:nickname],
        icon: user_data[:info][:image],
      )
      render 'users/new'
    end
  end



  def destroy
    log_out
    redirect_to root_url
  end
end
