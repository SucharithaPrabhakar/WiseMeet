class GroupsController < ApplicationController
before_action :correct_user, only: :destroy
before_action :logged_in_user, only: [:create, :destroy]

  def destroy
    if(group_admin?(@group.id))
      @group.destroy
      flash.now[:success] = "Group deleted"
      redirect_to root_url
    end 
  end 
  
  def new 
  end 

  def create
    group = {name: params[:name], content: params[:content], picture: params[:picture]}
    @group = Group.new(group)
    if @group.save
      @group.users << current_user
      flash.now[:success] = "Group created!"
      current_user.memberships.detect{ |e| e.group_id == @group.id }.update_attributes( lat: params[:map_lat], lng: params[:map_lng], admin: params[:admin] )
      redirect_to root_url
    else
      flash.now[:danger] = "Group creation failed!Invalid Group name"
      render 'new'
    end 
  end 

  def show
    @group = Group.find(params[:id]) || Group.find(params[:group_id])
  end 

  def addmember
    @group = Group.find(params[:format])
  end 

  def update
   @group = Group.find(params[:id])
   # Check if user is a part of the group
   email = params[:email].downcase
   if (@group.users.find_by(email: email))
      flash.now[:success] = "User Is A Member Of The Group"
      render :show
   else
     # If User exists, add the user to the group
     user = User.find_by(email: email)
     if(user && user.confirmed?)
       @group.users << user
       flash.now[:success] = "User Has Been Added To The Group"
       render :show
     elsif(user)
       #User exists but has not been activated.
       user.destroy
       password = SecureRandom.urlsafe_base64
       user = {name: params[:name], email: email, password: password, password_confirmation: password}
       # Add User to group
       @user = User.new(user)
       @user.skip_confirmation_notification! 
       if @user.save
         @user.send_confirmation_instructions
         @group.users << @user
         flash.now[:success] = "User Has Been Added To Group"
         render :show
      end
     else
      password = SecureRandom.urlsafe_base64
       user = {name: params[:name], email: email, password: password, password_confirmation: password}
       # Add User to group
       @user = User.new(user)
       @user.skip_confirmation_notification! 
       if @user.save
         @user.send_confirmation_instructions
         @group.users << @user
         flash.now[:success] = "User Has Been Added To Group"
         render :show
       end
     end
   end
  end

  def addlocation
   @group = Group.find(params[:format])
  end

  def savelocation
   @group = Group.find(params[:group_id])
   @membership = current_user.memberships.find_by(group_id: @group.id)
   if(@membership)
     @membership.update_attributes( lat: params[:map_lat], lng: params[:map_lng] )
     flash.now[:success] = "Your location has been saved"
     render :show
   else
     flash.now[:danger] = "Your location could not be saved"
     render :show
   end
  end

  def group_admin?(group_id)
    current_user.memberships.find_by(group_id: group_id).admin?
  end

  def removememberfromgroup
    user = User.find(params[:user_id])
    group = Group.find(params[:group_id])
    if group_admin?(group.id)
      group.memberships.find_by(user_id: user.id).destroy
      flash.now[:success] = "Member Has Been Deleted From Group"
      redirect_to group_path(group)
    else
      flash.now[:danger] = "Only Admin Can Remove A Member From Group"
      redirect_to group_path(group)
    end
  end

  def findplacetomeet
    @group = Group.find(params[:format])
    @memberships = @group.memberships
    @membership = @memberships.first
  end

  private

    def correct_user
      @group = current_user.groups.find_by(id: params[:id])
      redirect_to root_url if @group.nil?
    end
end
