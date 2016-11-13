class UsersController < ApplicationController

 def show
   @user = User.find(params[:id])
 end
 
 def update
  @user = User.find(params[:id])
  if(@user)
   @user.update_attributes(new_budget: params['new_budget'])
   @user.update_attributes(budget_change_reason: params['budget_change_reason'])
   flash.now[:success] = "Your budget has been updated"
   render :show
  else
    flash.now[:danger] = "Your budget could not be saved"
    render :show
  end
 end
end
