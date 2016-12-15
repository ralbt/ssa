class UsersController < ApplicationController
  def activate
    params.require(:email)
    @user = User.find_by(email: params[:email])
    if @user.present? && @user.created?
      @user.update_attribute(:status, User.statuses[:activated])
    end
  end
end
