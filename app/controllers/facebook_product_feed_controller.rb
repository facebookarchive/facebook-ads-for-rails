# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

# Renders products that +act_as_facebook_product_item+ in format compatible with Facebook product feeds
# (https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog)
class FacebookProductFeedController < ApplicationController

  SECONDS_PER_PRODUCT = 0 # TODO generate feed in background

  include Facebook::Ads
  include FacebookAdsHelper

  # Generates TSV file with all products that +act_as_facebook_product_item+
  def index
    product_items = product_models.map{|model| model.all.map(&:to_facebook_product_item)}.flatten
    require 'csv'
    feed = CSV.generate(col_sep: "\t") do |csv|
      csv << PRODUCT_ITEM_FIELDS
      product_items.each do |product|
        csv << PRODUCT_ITEM_FIELDS.map{|k| product[k]}
      end
    end
    render plain: feed
  end

  # Facebook sends +ping+ request before starting to upload a product feed.
  # This method returns number of seconds to wait before requesting the feed.
  def ping
    seconds_to_wait = (products_count * SECONDS_PER_PRODUCT).to_i
    render status: 200, plain: seconds_to_wait
  end
end
