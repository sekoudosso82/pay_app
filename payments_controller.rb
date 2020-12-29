class PaymentsController < ApplicationController
    
    def index 
      @payments = Payment.all
    end 
    def paypal_payments 
        @payments = Payment.all
        @paypal_payments = @payments.select { |pymnt| pymnt.transaction_instrument == 'paypal_account' }
    end 
    def card_payments 
        @payments = Payment.all
        @card_payments = @payments.select { |pymnt| pymnt.transaction_instrument == 'credit_card' }
    end 
  
    # def show 
    #     @payment = Payment.find(params[:id])
       
    # end

    private 
  
    def payment_params 
      params.require(:payment).permit(:transaction_id, :transaction_type, :transaction_amount, :transaction_currency, :transaction_instrument, :transaction_status)
    end 
  
end
