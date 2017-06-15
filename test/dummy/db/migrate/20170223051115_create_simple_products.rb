# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

class CreateSimpleProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :simple_products do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :brand
      t.integer :price
      t.string :currency
      t.string :condition
      t.string :category
      t.string :availability
      t.string :link
      t.boolean :visible
      t.timestamps
    end
  end
end
