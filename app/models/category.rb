class Category < ApplicationRecord
  validates :category_name, presence: true
  validates :description, presence: true

  has_many :products, class_name: "Product", foreign_key: "categoryid"
end
