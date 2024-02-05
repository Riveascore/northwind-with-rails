class Order < ApplicationRecord
  validates :customer_id, presence: true
  validates :employee_id, presence: true
  validates :order_date, presence: true
  validates :address_id, presence: true
  
  has_many :order_items, dependent: :destroy

  has_many :order_details, class_name: "OrderDetail", foreign_key: "orderid"

  belongs_to :employee 
  belongs_to :customer, class_name: 'Customer', foreign_key: 'customerid'
  belongs_to :address

end
