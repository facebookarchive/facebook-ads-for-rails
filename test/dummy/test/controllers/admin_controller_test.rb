# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/admin"
    assert_response :success
  end

end
