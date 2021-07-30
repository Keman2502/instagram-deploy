class WelcomeController < ApplicationController
  def index
    if not user_signed_in?
      redirect_to user_session_path
    else
      @post = current_user.posts
    end
  end
end
