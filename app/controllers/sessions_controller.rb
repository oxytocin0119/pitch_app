class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        # ユーザーログイン後にユーザー情報のページにリダイレクトする
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) 
        flash[:success] = 'ログインしました'
        redirect_back_or @user
      else
        message  = "アカウントが有効ではありません。"
        message += "メールに記載されたリンクを確認してください。"
        message += "（迷惑メールとして扱われている場合があります。）"
        flash[:warning] = message
        redirect_to root_url
      end
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
    # @user = User.find_by(twitter_id: user_data[:info][:nickname])
    @user = User.find_by(twitter_uid: user_data[:uid])

    if @user
      @user.twitter_id = user_data[:info][:nickname] if @user.twitter_id != user_data[:info][:nickname]
      log_in @user
      flash[:success] = 'ログインしました'
      redirect_back_or @user
    else
      @user = User.new(
        name: user_data[:info][:name],
        twitter_id: user_data[:info][:nickname],
        icon: user_data[:info][:image],
        twitter_uid: user_data[:uid],
      )
      render 'users/new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました'
    redirect_to root_url
  end

end
