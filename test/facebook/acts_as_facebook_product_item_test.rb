# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'test_helper'

class ActsAsFacebookProductItemTest < ActiveSupport::TestCase

  def test_facebook_product_item_mapping
    h = {:id=>:id, :availability=>:availability, :condition=>:condition, :description=>:description, :image_link=>:image, :link=>:link, :title=>:title, :price=>:price, :price_currency=>:currency, :additional_image_link=>:additional_image_link,:age_group=>:age_group, :applink=>:applink, :google_product_category=>:category, :color=>:color, :commerce_product_item_id=>:commerce_product_item_id, :custom_label_0=>:custom_label_0, :custom_label_1=>:custom_label_1, :custom_label_2=>:custom_label_2, :custom_label_3=>:custom_label_3, :custom_label_4=>:custom_label_4, :expiration_date=>:expiration_date, :gender=>:gender, :inventory=>:inventory, :material=>:material, :name=>:name, :pattern=>:pattern, :price_amount=>:price_amount, :product_type=>:product_type, :retailer_id=>:retailer_id, :sale_price=>:sale_price, :sale_price_amount=>:sale_price_amount, :sale_price_currency=>:sale_price_currency, :sale_price_start_date=>:sale_price_start_date, :sale_price_end_date=>:sale_price_end_date, :shipping=>:shipping, :shipping_country=>:shipping_country, :shipping_price_currency=>:shipping_price_currency, :shipping_region=>:shipping_region, :shipping_service=>:shipping_service, :shipping_price_value=>:shipping_price_value, :shipping_weight_value=>:shipping_weight_value, :shipping_weight_unit=>:shipping_weight_unit, :short_description=>:short_description, :size=>:size, :start_date=>:start_date, :variant=>:variant, :variant_label=>:variant_label, :variant_options=>:variant_options, :variant_value=>:variant_value, :videos=>:videos, :retailer_group_id=>:retailer_group_id, :webitemid=>:webitemid, :ios_url=>:ios_url, :ios_app_store_id=>:ios_app_store_id, :ios_app_name=>:ios_app_name, :iphone_url=>:iphone_url, :iphone_app_store_id=>:iphone_app_store_id, :iphone_app_name=>:iphone_app_name, :ipad_url=>:ipad_url, :ipad_app_store_id=>:ipad_app_store_id, :ipad_app_name=>:ipad_app_name, :android_url=>:android_url, :android_package=>:android_package, :android_app_name=>:android_app_name, :windows_phone_url=>:windows_phone_url, :windows_phone_app_id=>:windows_phone_app_id, :windows_phone_app_name=>:windows_phone_app_name, :web_should_fallback=>:web_should_fallback, :gtin=>:gtin, :mpn=>:mpn, :brand=>:brand}
    assert_equal h, SimpleProduct.facebook_product_item_mapping
  end

  def test_to_facebook_product_item
    expect = {:brand=>nil, :id=>"SimpleProduct-", :availability=>nil, :condition=>nil, :description=>nil, :image_link=>nil, :link=>nil, :title=>nil, :price=>nil, :price_currency=>nil, :google_product_category=>nil}
    assert_equal expect, SimpleProduct.new.to_facebook_product_item
  end

  def test_to_facebook_product_item_initialized
    expect = {:brand=>"brand", :id=>"SimpleProduct-123", :availability=>"in stock", :condition=>"new", :description=>"desc", :image_link=>nil, :link=>nil, :title=>"title", :price=>234, :price_currency=>nil, :google_product_category=>"phones"}
    assert_equal expect, SimpleProduct.new(id: 123, title: 'title', description: 'desc', brand: 'brand', price: 234, availability: "in stock", condition: "new", category: "phones").to_facebook_product_item
  end
end