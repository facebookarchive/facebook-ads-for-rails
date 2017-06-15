# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'test_helper'

class FacebookProductFeedControllerTest < ActionDispatch::IntegrationTest
  test "should get product feed" do
    get facebook_product_feed_path
    assert_response :success
    expect =<<EOS
id\tavailability\tcondition\tdescription\timage_link\tlink\ttitle\tprice\tprice_currency\tadditional_image_link\tage_group\tapplink\tgoogle_product_category\tcolor\tcommerce_product_item_id\tcustom_label_0\tcustom_label_1\tcustom_label_2\tcustom_label_3\tcustom_label_4\texpiration_date\tgender\tinventory\tmaterial\tname\tpattern\tprice_amount\tproduct_type\tretailer_id\tsale_price\tsale_price_amount\tsale_price_currency\tsale_price_start_date\tsale_price_end_date\tshipping\tshipping_country\tshipping_price_currency\tshipping_region\tshipping_service\tshipping_price_value\tshipping_weight_value\tshipping_weight_unit\tshort_description\tsize\tstart_date\tvariant\tvariant_label\tvariant_options\tvariant_value\tvideos\tretailer_group_id\twebitemid\tios_url\tios_app_store_id\tios_app_name\tiphone_url\tiphone_app_store_id\tiphone_app_name\tipad_url\tipad_app_store_id\tipad_app_name\tandroid_url\tandroid_package\tandroid_app_name\twindows_phone_url\twindows_phone_app_id\twindows_phone_app_name\tweb_should_fallback\tgtin\tmpn\tbrand
SimpleProduct-298486374\tin stock\tused\tproduct2 desc\thttp://example.com/image2.jpg\t\tproduct2\t10001\tUSD\t\t\t\tapparel\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tbrand2
SimpleProduct-759298258\tin stock\tused\tproduct3 desc\thttp://example.com/image3.jpg\t\tproduct3\t654\tCAD\t\t\t\tapparel\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tbrand3
SimpleProduct-980190962\tin stock\tnew\tproduct1 description\thttp://example.com/image.jpg\t\tproduct1\t99\tUSD\t\t\t\tphones\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tbrand1
EOS
    assert_equal expect,response.body
  end
end
