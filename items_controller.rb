class ItemsController < ApplicationController
    before_action :find_item, only: [:edit, :update, :destroy]
  
    def index 
      @items = Item.all
    
    end 
  
    def show 
        @item = Item.find(params[:id])
       
    end
    
    def new 
      @item = Item.new
      # @errors = flash[:errors]
    #   render :new 
    end 
    
    def create 
      
      @item = Item.create(item_params)
        if @item.valid?
          redirect_to items_path(@item)
        else
          flash[:errors] = @item.errors.full_messages
          redirect_to new_item_path
        end 
    end 
    
    def edit 
    #   @item = Item.find(params[:id])
      render :edit
    end 
    
    def update
      if @item.update(item_params)
        redirect_to item_path(@item.id)
      else
        flash[:errors] = @item.errors.full_messages
        redirect_to edit_item_path(@item)
      end  
    end 

    def destroy 
    #   @item = Item.find(params[:id])
      @item.destroy 
      redirect_to items_path(@item)
    end 
  
    private 
  
    def item_params 
      params.require(:item).permit(:user_id, :description, :img_url, :price)
    end 
  
    def find_item
      @item = Item.find(params[:id])
    end 

end