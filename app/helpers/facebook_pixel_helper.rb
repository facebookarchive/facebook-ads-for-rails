# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

module FacebookPixelHelper

  # Triggers Facebook event in javascript scope
  # * +event+ is event name like +ViewContent+, +AddToCart+, etc.
  # * +products+ is a collection of models that +act_as_facebook_product_item+
  # * +fields+ is a collection of fields that should present in this event
  # * +overrides+ may include additional parameters of the event
  #
  # ==== Examples
  #    fb_event_js("ViewContent", [product], [:value, :currency, :content_name, :content_type, :content_ids], {})
  #    fb_event_js "Purchase", products, [:value, :currency, :content_name, :content_type, :content_ids, :num_items], {}
  #
  # Read more about Facebook Pixel events: https://www.facebook.com/business/help/952192354843755
  #                                        https://developers.facebook.com/docs/ads-for-websites/pixel-events#events
  def fb_event_js event, products, fields, overrides = {}
    return '' if products.empty?
    fb_products = products.map do |p|
      raise ArgumentError, "products must act_as_facebook_product" unless p.respond_to? :to_facebook_product_item
      p.to_facebook_product_item
    end
    default_fields = fields - overrides.keys
    currency = "USD"
    options = default_fields.sort.map do |field|
      value = case field
        when :value
          # :currency is always initialized before :value
          fb_products.select{|h| h[:price_currency] == currency}.map{|h| h[:price]}.inject(0, &:+)
        when :currency
          currency = product_default_currency(products)
        when :content_name
          # TODO How to generate single title for multiple products?
          fb_products.first[:title]
        when :content_type
          "product"
        when :content_ids
          fb_products.map{|p| p[:id]}
        when :content_category
          # TODO How to generate single category for multiple products?
          categories = fb_products.map{|p| p[:google_product_category]}
          categories.group_by{|v| v}.max{|x,y| x[1].length <=> y[1].length}.first
        when :num_items
          products.count
      else
        raise RuntimeError, "Invalid field name #{field}"
      end
      [field, value]
    end.to_h
    json = options.merge(overrides).to_json
    Setting.first.try(:pixel_id) ? raw("fbq('track', '#{event}', #{json});") : ''
  end

  # Triggers facebook event in a script tag
  # See also +fb_event_js+
  def fb_event event, products, options = {}
    raw javascript_tag(fb_event_js(event, products, options))
  end

  # Triggers +ViewContent+ event in javascript scope:
  #   <%=link_to 'show product', product_path(product), onclick: fb_view_content_js(product)%>
  def fb_view_content_js product, options = {}
    fb_event_js("ViewContent", [product], [:value, :currency, :content_name, :content_type, :content_ids], options)
  end

  # Triggers +ViewContent+ event in a script tag:
  #   <%=fb_view_content(product)%>
  def fb_view_content product, options = {}
    javascript_tag fb_view_content_js(product, options)
  end

  # Triggers +Search+ event in javascript scope:
  def fb_search_js search_string, products, options = {}
    fb_event_js("Search", products, [:value, :currency, :content_category, :content_ids], search_string: search_string)
  end

  # Triggers +Search+ event in a script tag:
  #   <%=fb_search(@search_query, @search_result_products)%>
  def fb_search search_string, products, options = {}
    javascript_tag fb_search_js(search_string, products, options)
  end

  # Triggers +AddToCart+ event in javascript scope:
  #  <%=link_to "Add to cart", add_to_cart_my_product_path(my_product), class: "btn btn-primary", onclick: fb_add_to_cart_js([my_product])%>
  def fb_add_to_cart_js products, options = {}
    fb_event_js "AddToCart", products, [:value, :currency, :content_name, :content_type, :content_ids], options
  end

  # Triggers +AddToCart+ event in a script tag:
  #  <%=fb_add_to_cart_js(my_product)%>
  def fb_add_to_cart products, options = {}
    javascript_tag fb_add_to_cart_js(products, options)
  end

  # Triggers +AddToWishlist+ event in javascript scope:
  #  <%=link_to "Add to wishlist", add_to_wishlist_my_product_path(my_product), onclick: fb_add_to_wishlist_js(my_product)%>
  def fb_add_to_wishlist_js products, options = {}
    fb_event_js "AddToWishlist", products, [:value, :currency, :content_name, :content_category, :content_ids], options
  end

  # Triggers +AddToWishlist+ event in a script tag:
  #  <%=fb_add_to_wishlist_js(my_product)%>
  def fb_add_to_wishlist products, options = {}
    javascript_tag fb_add_to_wishlist_js(products, options)
  end

  # Triggers +InitiateCheckout+ event in javascript scope:
  #   <%=link_to "Checkout", checkout_my_products_path, class: "btn btn-primary", onclick: fb_initiate_checkout_js(@my_products)%>
  def fb_initiate_checkout_js products, options = {}
    fb_event_js "InitiateCheckout", products, [:value, :currency, :content_name, :content_category, :content_ids, :num_items], options
  end

  # Triggers +InitiateCheckout+ event in a script tag:
  #   <%=fb_initiate_checkout(@my_products)%>
  def fb_initiate_checkout products, options = {}
    javascript_tag fb_initiate_checkout_js(products, options)
  end

  # Triggers +AddPaymentInfo+ event in javascript scope
  #   <%=link_to "AddPaymentInfo", add_payment_path, onclick: fb_add_payment_info_js(@my_products)%>
  def fb_add_payment_info_js products, options = {}
    fb_event_js "AddPaymentInfo", products, [:value, :currency, :content_category, :content_ids], options
  end

  # Triggers +AddPaymentInfo+ event in a script tag:
  #   <%=fb_add_payment_info(@my_products)%>
  def fb_add_payment_info products, options = {}
    javascript_tag fb_add_payment_info_js(products, options)
  end

  # Triggers +Purchase+ event in javascript scope
  #   <%=link_to "Purchase!", purchase_my_products_path, onclick: fb_purchase_js(@my_products)%>
  def fb_purchase_js products, options = {}
    fb_event_js "Purchase", products, [:value, :currency, :content_name, :content_type, :content_ids, :num_items], options
  end

  # Triggers +Purchase+ event in a script tag
  #   <%=fb_purchase(@my_products)%>
  def fb_purchase products, options = {}
    javascript_tag fb_purchase_js(products, options)
  end

  # Triggers +Lead+ event in javascript scope
  def fb_lead_js products = [], options = {}
    fb_event_js "Lead", products, [:value, :currency, :content_name, :content_category], options
  end

  # Triggers +Lead+ event in a script tag
  #   <%=fb_lead(@my_products)%>
  def fb_lead products = [], options = {}
    javascript_tag fb_lead_js(products, options)
  end

  # Triggers +CompleteRegistration+ event in javascript scope
  # TODO document list of acceptable statuses
  def fb_complete_registration_js status, products = [], options = {}
    fb_event_js "CompleteRegistration", products, [:value, :currency, :content_name], options.merge(status: status)
  end

  # Triggers +CompleteRegistration+ event in a script tag
  #   <%=fb_complete_registration(@my_products)%>
  def fb_complete_registration status, products = [], options = {}
    javascript_tag fb_complete_registration_js(status, products, options)
  end

  # Tries to guess if current action/view shows contents of a product that acts_as_facebook_product_item
  # and triggers ViewContent event in that case
  def fb_view_content_magic params = request.params
    models = product_models.map(&:name)
    model_name = params[:controller].to_s.singularize.camelize
    if models.index model_name and params[:action].to_s == "show"
      fb_products = instance_values.values.select do |value|
        models.index value.class.name
      end
      return fb_view_content(fb_products.first) if fb_products.count == 1
    end
    ""
  end

  # Installs common pixel code to the page
  # Insert this line into your layout file in <header> section:
  #
  #   <%=init_facebook_pixel%>
  #
  # If +fire_view_content+ == true, this call will fire ViewContent event when the page looks like a product page
  def init_facebook_pixel(fire_view_content = true)
    return if Setting.first.nil?
    raise RuntimeError, "init_facebook_pixel is called twice" if @init_facebook_pixel
    @init_facebook_pixel = true
    render(partial: "pixel/init_facebook_pixel").tap do |init_pixel|
      init_pixel += fb_view_content_magic if fire_view_content
    end
  end
end