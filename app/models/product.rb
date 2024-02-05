class Product < ApplicationRecord
  before_save { self.product_code = product_code.upcase }
  validates :product_code, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :product_name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :standard_cost, presence: true
  validates :list_price, presence: true
  validates :discontinued, presence: true

  scope :product_code_like, ->(query) { where('product_code LIKE ?', "%#{query}%") }
  scope :product_name_like, ->(query) { where('product_name LIKE ?', "%#{query}%") }
  scope :product_code_or_product_name_like, -> (query) { product_code_like(query).or(product_name_like(query)) }

  belongs_to :category, class_name: "Category", foreign_key: "categoryid"
  belongs_to :supplier, class_name: "Supplier", foreign_key: "supplierid"

  has_many :order_details, class_name: "OrderDetail", foreign_key: "productid"

  scope :average_quantity_by_product_name, -> do
    joins(:order_details)
      .group(:productname)
      .select(
        :productname, 
        'ROUND(AVG(quantity)) AS average_quantity'
      )
      .order('average_quantity DESC')
  end

  class << self

    def average_quantity_by_product
      average_quantity_by_product_name.to_a.pluck(
        :productname,
        :average_quantity
      )
    end
    
  end
  
  def self.name_like(q)
    products = product_code_or_product_name_like(q)
    products.uniq
  end

end
