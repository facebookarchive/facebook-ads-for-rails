# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'test_helper'

class FacebookAdsHelperTest < ActionView::TestCase
  test "fb event ViewContent" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'ViewContent', {"content_ids":["SimpleProduct-980190962"],"content_name":"product1","content_type":"product","currency":"USD","value":99});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_view_content(simple_products(:one))
  end

  test "fb event ViewContent js" do
    expect =<<EOS
fbq('track', 'ViewContent', {"content_ids":["SimpleProduct-980190962"],"content_name":"product1","content_type":"product","currency":"USD","value":99});
EOS
    assert_equal expect.strip, fb_view_content_js(simple_products(:one))
  end

  test "fb event Search" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'Search', {"content_category":"phones","content_ids":["SimpleProduct-980190962"],"currency":"USD","value":99,"search_string":"Search query"});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_search("Search query", [simple_products(:one)])
  end

  test "fb event Search js" do
    expect =<<EOS
fbq('track', 'Search', {"content_category":"phones","content_ids":["SimpleProduct-980190962"],"currency":"USD","value":99,"search_string":"Search query"});
EOS
    assert_equal expect.strip, fb_search_js("Search query", [simple_products(:one)])
  end

  test "fb event AddToCart" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'AddToCart', {"content_ids":["SimpleProduct-980190962"],"content_name":"product1","content_type":"product","currency":"USD","value":99});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_add_to_cart([simple_products(:one)])
  end

  test "fb event AddToCart js" do
    expect =<<EOS
fbq('track', 'AddToCart', {"content_ids":["SimpleProduct-980190962"],"content_name":"product1","content_type":"product","currency":"USD","value":99});
EOS
    assert_equal expect.strip, fb_add_to_cart_js([simple_products(:one)])
  end

  test "fb event AddToWishlist" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'AddToWishlist', {"content_category":"phones","content_ids":["SimpleProduct-980190962"],"content_name":"product1","currency":"USD","value":99});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_add_to_wishlist([simple_products(:one)])
  end

  test "fb event AddToWishlist js" do
    expect =<<EOS
fbq('track', 'AddToWishlist', {"content_category":"phones","content_ids":["SimpleProduct-980190962"],"content_name":"product1","currency":"USD","value":99});
EOS
    assert_equal expect.strip, fb_add_to_wishlist_js([simple_products(:one)])
  end
  
  test "fb event InitiateCheckout js" do
    expect =<<EOS
fbq('track', 'InitiateCheckout', {"content_category":"apparel","content_ids":["SimpleProduct-298486374","SimpleProduct-759298258","SimpleProduct-980190962"],"content_name":"product2","currency":"USD","num_items":3,"value":10100});
EOS
    assert_equal expect.strip, fb_initiate_checkout_js(SimpleProduct.all)
  end

  test "fb event InitiateCheckout" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'InitiateCheckout', {"content_category":"apparel","content_ids":["SimpleProduct-298486374","SimpleProduct-759298258","SimpleProduct-980190962"],"content_name":"product2","currency":"USD","num_items":3,"value":10100});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_initiate_checkout(SimpleProduct.all)
  end

  test "fb event AddPaymentInfo js" do
    expect =<<EOS
fbq('track', 'AddPaymentInfo', {"content_category":"apparel","content_ids":["SimpleProduct-298486374","SimpleProduct-759298258","SimpleProduct-980190962"],"currency":"USD","value":10100});
EOS
    assert_equal expect.strip, fb_add_payment_info_js(SimpleProduct.all)
  end

  test "fb event AddPaymentInfo" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'AddPaymentInfo', {"content_category":"apparel","content_ids":["SimpleProduct-298486374","SimpleProduct-759298258","SimpleProduct-980190962"],"currency":"USD","value":10100});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_add_payment_info(SimpleProduct.all)
  end

  test "fb event Purchase js" do
    expect =<<EOS
fbq('track', 'Purchase', {"content_ids":["SimpleProduct-298486374","SimpleProduct-759298258","SimpleProduct-980190962"],"content_name":"product2","content_type":"product","currency":"USD","num_items":3,"value":10100});
EOS
    assert_equal expect.strip, fb_purchase_js(SimpleProduct.all)
  end

  test "fb event Purchase" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'Purchase', {"content_ids":["SimpleProduct-298486374","SimpleProduct-759298258","SimpleProduct-980190962"],"content_name":"product2","content_type":"product","currency":"USD","num_items":3,"value":10100});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_purchase(SimpleProduct.all)
  end

  test "fb event Lead js" do
    expect =<<EOS
fbq('track', 'Lead', {"content_category":"apparel","content_name":"product2","currency":"USD","value":10100});
EOS
    assert_equal expect.strip, fb_lead_js(SimpleProduct.all)
  end

  test "fb event Lead" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'Lead', {"content_category":"apparel","content_name":"product2","currency":"USD","value":10100});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_lead(SimpleProduct.all)
  end

  test "fb event CompleteRegistration js" do
    expect =<<EOS
fbq('track', 'CompleteRegistration', {"content_name":"product2","currency":"USD","value":10100,"status":"success"});
EOS
    assert_equal expect.strip, fb_complete_registration_js("success", SimpleProduct.all)
  end

  test "fb event CompleteRegistration" do
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'CompleteRegistration', {"content_name":"product2","currency":"USD","value":10100,"status":"success"});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_complete_registration("success", SimpleProduct.all)
  end

  test "fb view content magic" do
    @product = simple_products(:one)
    expect =<<EOS
<script>
//<![CDATA[
fbq('track', 'ViewContent', {"content_ids":["SimpleProduct-980190962"],"content_name":"product1","content_type":"product","currency":"USD","value":99});
//]]>
</script>
EOS
    assert_equal expect.strip, fb_view_content_magic(controller: "simple_products", action: "show")
    assert_equal "", fb_view_content_magic(controller: "simple_products", action: "edit")
    assert_equal "", fb_view_content_magic(controller: "random_controller", action: "no_action")
    assert_equal "", fb_view_content_magic({})
  end

  test "init facebook pixel" do
    @init_facebook_pixel = false
    expect =<<EOS
<!-- Facebook Pixel Code -->
<script>
    !function (f, b, e, v, n, t, s) {
        if (f.fbq)return;
        n = f.fbq = function () {
            n.callMethod ?
                n.callMethod.apply(n, arguments) : n.queue.push(arguments)
        };
        if (!f._fbq) f._fbq = n;
        n.push = n;
        n.loaded = !0;
        n.version = '2.0';
        n.queue = [];
        t = b.createElement(e);
        t.async = !0;
        t.src = v;
        s = b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t, s)
    }(window,
        document, 'script', 'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '123'); // Insert your pixel ID here.
</script>
<noscript><img height=\"1\" width=\"1\" style=\"display:none\"
               src=\"https://www.facebook.com/tr?id=123&noscript=1\"
/></noscript>
<!-- DO NOT MODIFY -->
<!-- End Facebook Pixel Code -->
EOS
    assert_equal expect.strip, init_facebook_pixel(false)
    assert_raises(RuntimeError){init_facebook_pixel(false)}
  end

end