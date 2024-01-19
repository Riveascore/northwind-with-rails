class OrderDetail < ApplicationRecord

  belongs_to :order, foreign_key: 'orderid'
  belongs_to :product, foreign_key: 'productid'

  validates :product_id, :order_id, :quantity, presence: true
  validates :product_id, uniqueness: { scope: :order_id}

  scope :by_order, ->(order_id) { where(order_id: order_id) }

end
