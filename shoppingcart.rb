class Shoppingcart < ApplicationRecord
  belongs_to :user

  has_many :shoppingcart_items, dependent: :destroy

  has_many :items, through: :shoppingcart_items
 
end
