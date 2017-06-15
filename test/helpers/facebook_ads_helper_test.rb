# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'test_helper'

class FacebookAdsHelperTest < ActionView::TestCase
  test "products count" do
    assert_equal 3, products_count
  end

  test "products models" do
    assert_equal "SimpleProduct", product_models.map(&:to_s).join
    Rails.configuration.eager_load = true
    assert_equal "SimpleProduct", product_models.map(&:to_s).join
    Rails.configuration.eager_load = false
  end

  test "product samples" do
    assert_equal 3, product_samples.count
    assert_equal 0, product_samples(10, []).count
  end

  test "product default currency" do
    assert_equal "USD", product_default_currency
    assert_equal "USD", product_default_currency([])
  end

  test "open ads window" do
    html = open_facebook_ads_window("__ads_open_button__")
    product_samples.each do |sample|
      assert_match sample.to_facebook_product_item.to_json, html
    end
    assert_match "__ads_open_button__", html
  end

  test "root url" do
    assert_equal 'http://localhost', fb_root_url(host: 'http://localhost')
    assert_equal 'http://localhost:3000', fb_root_url(host: 'http://localhost:3000')
    assert_equal 'http://localhost', fb_root_url(host: 'localhost')
    assert_equal 'http://localhost:3000', fb_root_url(host: 'localhost:3000')
    assert_equal 'https://localhost:3000', fb_root_url(host: 'localhost:3000', protocol: 'https')
    assert_equal 'http://localhost:3000', fb_root_url(host: 'http://localhost/', port: 3000)
    assert_equal 'http://localhost:3000', fb_root_url(host: 'localhost', port: 3000)
    assert_equal 'https://localhost:3000', fb_root_url(host: 'localhost', port: 3000, protocol: "https")

    assert_equal 'http://localhost:3000', fb_root_url
  end
end