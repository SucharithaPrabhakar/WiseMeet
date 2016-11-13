class StaticPagesController < ApplicationController
  def home
    @group = current_user.groups.build if user_signed_in?
    @groups_to_which_user_belongs = current_user.groups.paginate(page: params[:page]) if user_signed_in?
  end 

  def about
  end

  def contact
  end
end
