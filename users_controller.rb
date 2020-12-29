class UsersController < ApplicationController
    skip_before_action :authorized, only: [:new, :create]    
    before_action :find_user, only: [:show, :edit, :update, :destroy]

    # def index 
    #     @users = User.all 
    # end
    
    def show 
        @user = User.find(session[:user_id])
    end

    def new 
        @user = User.new
        @errors = flash[:errors]
    end

    def create 
        @user = User.create(user_params)
        if @user.valid?
          # create a shoppingcart automatically when user sign up
          @shoppingcart = Shoppingcart.create(
            user_id: @user.id,
            # user_id: params[:user_id],
          )
            redirect_to  @user
        else
            flash[:errors] = @user.errors.full_messages
            redirect_to new_user_path 
        end 
    end

    def edit 
        if current_user != @user 
            redirect_to current_user
        else
            render :edit
        end
    end

    def update 
        # @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to user_path(@user.id)
      else
        flash[:errors] = @user.errors.full_messages
        redirect_to edit_user_path(@user)
      end 
    end

    def destroy 
      # destroy shoppingcart first
      @shoppingcart = Shoppingcart.find(params[:id])
      @shoppingcart.destroy 
      # then destroy user account
      @user.destroy 
      flash[:notice] = 'You deleted your account!'

      redirect_to users_path
    end

    private 
    def user_params 
        params.require(:user).permit(:username, :full_name, :email, :phone, :password)
    end 

    def find_user
        @user = User.find(params[:id])
    end 
end