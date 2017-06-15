# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

class SimpleProduct < ApplicationRecord
  default_scope -> {where(visible: true)}

  acts_as_facebook_product_item google_product_category: :category, image_link: :image, price_currency: :currency
end
