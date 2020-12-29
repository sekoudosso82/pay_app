class ShoppingcartItemsController < ApplicationController
    def index 
        @shoppingcart_items = ShoppingcartItem.all
    end
    
    def show
        @shoppingcart_item = ShoppingcartItem.find(params[:id])
    end

    def new
        @shoppingcart_item = Item.find(params[:id])
        ShoppingcartItem.create(
            shoppingcart_id: current_user.id, # current_user.id, 
            item_id: @shoppingcart_item.id

        )
    end
    def add_to_cart()
        
        ShoppingcartItem.create(
            shoppingcart_id: current_user.id, # current_user.id, 
            item_id: params[:id]
        )
        redirect_to items_path(@items)
        
    end
     
    def update
        @shoppingcart_item = ShoppingcartItem.find(params[:id])
        if @shoppingcart_item.update(shoppingcart_item_params)
          redirect_to items_path(@items)
        else
          flash[:errors] = @shoppingcart_item.errors.full_messages
          redirect_to edit_shoppingcart_item_path(@shoppingcart_item)
        end  
    end 
      
    def destroy 
        @shoppingcart_item = ShoppingcartItem.find(params[:id])
        @shoppingcart_item.destroy
        redirect_to shoppingcarts_path()
        
    end 

    private

    def shoppingcart_item_params
        params.require(:shoppingcart_item).permit(:shoppingcart_id, :item_id)
    end
end