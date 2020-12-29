class ShoppingcartsController < ApplicationController
    def index
        @shoppingcarts = ShoppingcartItem.all.select {|elmnt| elmnt.shoppingcart.user_id == current_user.id }
    end

    def new
        @shoppingcart = Shoppingcart.new
    end

    private

    def shoppingcart_params
        params.require(:shoppingcart).permit(:user_id)
    end
end