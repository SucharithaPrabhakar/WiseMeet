class OmniauthCallbacksController < ApplicationController

 def facebook
  # You need to implement the method below in your model (e.g. app/models/user.rb)
  @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

  if @user.persisted?

    session[:sn_user] = request.env['omniauth.params']

    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

    flash[:success] = "Hi!! #{@user.name}, Welcome to (: WiseMeet :)"

  else

    session['devise.facebook_data'] = request.env['omniauth.auth']

    redirect_to new_user_registration_url

  end

 end

 def google_oauth2

  @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

  if @user.persisted?

    session[:sn_user] = request.env['omniauth.params']

    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

    flash[:success] = "Hi!! #{@user.name}, Welcome to (: WiseMeet :)"

  else

    session["devise.google_data"] = request.env["omniauth.auth"]

    redirect_to new_user_registration_url

  end

 end

 def failure
  flash[:danger] = "Authentication failed!!. Try again"
  redirect_to root_url
 end

#def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
 #   data = access_token.info
 #   user = User.where(:email => data["email"]).first

 #   unless user
 #     user = User.create(name: data["name"],
 #            email: data["email"],
 #            password: Devise.friendly_token[0,20]
 #             )
 #      end
 #   user
 #end

end

