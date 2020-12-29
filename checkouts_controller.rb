class CheckoutsController < ApplicationController
  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]

  def index 
    @transactions = gateway.transaction.all 
  end
  def new
    # byebug
    @item_price = Item.find(params[:item_id]).price
    @client_token = gateway.client_token.generate

  end
  # vault credit card 
  def vault_credit_card
    # return nil if credit_card_details.token.nil?
    # vaulted = @gateway.credit_card.find(credit_card_details.token)
  end

  def show
    # byebug 
    @transaction = gateway.transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
  end
  
  def create
    # byebug 
    amount =  params["amount"]  
    nonce = params["payment_method_nonce"]
    nonce_from_the_client = params[:payment_method_nonce]
    
    result = gateway.transaction.sale(
      amount: amount,
      payment_method_nonce: nonce_from_the_client,
      :options => {
        :submit_for_settlement => true
      }
    )
    # submit for settlement when a transaction in completed
    # if result.success?
    #   next_result = gateway.transaction.submit_for_settlement(result.transaction.id)
    #   settled_transaction = result.transaction
    # else
    #   puts(result.message)
    # end
    # vault credit card 
    if result.success? 
        vault_result = gateway.payment_method.create(
          customer_id: current_user.id, # "131866",
          payment_method_nonce: nonce_from_the_client,
          :options => {
            :make_default => true
          }
        ) 
    else
      puts(result.message)
    end
    
    if result.success? || result.transaction
      Payment.create(
        transaction_id: result.transaction.id, 
        transaction_type: result.transaction.type, 
        transaction_amount: result.transaction.amount, 
        transaction_currency: result.transaction.currency_iso_code, 
        transaction_instrument: result.transaction.payment_instrument_type, 
        transaction_status: result.transaction.status
      )
      redirect_to checkout_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to items_path
    end
  end

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your test transaction has been successfully processed. See the Braintree API response and try again."
      }
    else
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your test transaction has a status of #{status}. See the Braintree API response and try again."
      }
    end
  end
  # render all transactions
  def all_transactions
    # byebug 
    @search_results = gateway.transaction.search
  end 
  # filter paypal transactions
  def paypal_transactions
    # byebug 
    @search_results = gateway.transaction.search
    @paypal_payments = @search_results.select { |pymnt| pymnt.payment_instrument_type == 'paypal_account' }
  end 
  # filter credit cards transactions
  def card_transactions
    # byebug 
    @search_results = gateway.transaction.search
    @card_payments = @search_results.select { |pymnt| pymnt.payment_instrument_type == 'credit_card' }
  end 
  # filter refunded a transaction
  def refunded_transactions
    # byebug 
    @search_results = gateway.transaction.search
    @refunded_transactions = @search_results.select { |pymnt| pymnt.refunded?}
  end 


  
  def refund_transaction 
    result = gateway.transaction.refund(params[:payment_id])
    if result.success? 
      result.transaction.status
      result.transaction.processor_response_code
      result.transaction.processor_response_text
      redirect_to checkout_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to items_path
    end
  end 

  # def submit_settlement 
  #   result = gateway.transaction.submit_for_settlement("the_transaction_id")
  #   if result.success?
  #     settled_transaction = result.transaction
  #   else
  #     puts(result.message)
  #   end
  # end

  def gateway
    env = ENV["BT_ENVIRONMENT"]

    @gateway ||= Braintree::Gateway.new(
      :environment => env && env.to_sym,
      :merchant_id => ENV["BT_MERCHANT_ID"],
      :public_key => ENV["BT_PUBLIC_KEY"],
      :private_key => ENV["BT_PRIVATE_KEY"],
    )
  end
end
