module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      # 未サインインの場合、サインイン後にまたこの場所に戻ってこられるよう、現在の位置を一時保管しておく
      store_location
      # そして、サインインページにリダイレクトさせる（このときflashを使って「Please sign in.」と表示させる
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    # リクエストされたURIが存在する場合はそこに、ない場合は何らかのデフォルトURIにリダイレクトする。
    redirect_to(session[:return_to] || default)

    # 保管してあった転送用のURIを削除する。これをしないと、次回サインインしたときに保護されたページに転送されてしまい、
    # ブラウザを閉じるまでこれが繰り返されてしまう。
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
