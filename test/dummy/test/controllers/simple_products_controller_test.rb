# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'test_helper'

class SimpleProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simple_product = simple_products(:one)
    Setting.create(pixel_id: 123)
  end

  test "should get index" do
    get simple_products_url
    assert_response :success
    assert_match /fbq\('track', 'AddToCart', \{&quot;content_ids&quot;:\[&quot;SimpleProduct-759298258&quot;\],&quot;content_name&quot;:&quot;product3&quot;,&quot;content_type&quot;:&quot;product&quot;,&quot;currency&quot;:&quot;CAD&quot;,&quot;value&quot;:654\}\);/, response.body
  end

  test "should get new" do
    get new_simple_product_url
    assert_response :success
  end

  test "should create simple_product" do
    assert_difference('SimpleProduct.count') do
      post simple_products_url, params: { simple_product: { availability: @simple_product.availability, brand: @simple_product.brand, category: @simple_product.category, condition: @simple_product.condition, description: @simple_product.description, image: @simple_product.image, price: @simple_product.price, title: @simple_product.title } }
    end

    assert_redirected_to simple_product_url(SimpleProduct.last)
  end

  test "should show simple_product" do
    get simple_product_url(@simple_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_simple_product_url(@simple_product)
    assert_response :success
  end

  test "should update simple_product" do
    patch simple_product_url(@simple_product), params: { simple_product: { availability: @simple_product.availability, brand: @simple_product.brand, category: @simple_product.category, condition: @simple_product.condition, description: @simple_product.description, image: @simple_product.image, price: @simple_product.price, title: @simple_product.title } }
    assert_redirected_to simple_product_url(@simple_product)
  end

  test "should destroy simple_product" do
    assert_difference('SimpleProduct.count', -1) do
      delete simple_product_url(@simple_product)
    end

    assert_redirected_to simple_products_url
  end
end
