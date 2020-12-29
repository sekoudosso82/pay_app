class User < ApplicationRecord
    has_secure_password 
    validates :username, uniqueness: true
    validates :username, uniqueness: { case_sensitive: true }
    validates :password, length: { in: 3..20 }
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

    has_one :shoppingcart, dependent: :destroy
   
    has_many :items, dependent: :destroy
    
end