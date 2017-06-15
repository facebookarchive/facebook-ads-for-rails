# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

module FacebookAdsHelper

  # Generates an HTML link that opens a Facebook dialog that configures integration of the application with Facebook dynamic ads
  # After user successfully completes the setup process in the opened window:
  # * Facebook pixel id (https://www.facebook.com/business/help/952192354843755) is installed to the application,
  # * Regular product feed upload is scheduled (see https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog)
  #
  # ==== Parameters
  #
  # * +link_name+ - text on the link
  # * +store_name+ - name of the store
  # * +store_version+ - version of the store
  # * +currency+ - currency. Currently only a single currency is supported
  # * +timezone+ - timezone. See https://developers.facebook.com/docs/marketing-api/reference/ad-account/timezone-ids/v2.8 for the list of constants
  # * +html_options+ - additional html attributes
  # * +root_url+ - root url of the website
  # * +update_settings_path+ - url of SettingsController. Override default value to use custom SettingsController (e.g. with authorization)
  # * +facebook_dia_url+ - url of Facebook popup window. Can be overridden for debugging purposes
  def open_facebook_ads_window(link_name = "Connect to Facebook",
                               store_name = "Shop on Rails",
                               store_version = "1.0.0",
                               currency = product_default_currency,
                               timezone = TZ_UNKNOWN,
                               html_options = {},
                               root_url = fb_root_url,
                               update_settings_path = facebook_update_settings_path,
                               facebook_dia_url = "https://www.facebook.com/ads/dia/")
    render partial: "settings/open_dia_window", locals: {
        name: link_name,
        store_name: store_name,
        currency: currency,
        timezone: timezone,
        html_options: html_options,
        root_url: root_url,
        update_settings_path: update_settings_path,
        facebook_dia_url: facebook_dia_url,
        store_version: store_version
    }
  end

  # DIA currently supports only a single currency. This heuristic finds the most used currency
  def product_default_currency(product_list = product_samples(1000))
    currencies = product_list.map{|p| p.to_facebook_product_item[:price_currency]}.group_by(&:to_s)
    currencies.map{|currency, items| [items.count, currency]}.max.try(:at, 1) || "USD"
  end

  # Number of all products that are exported to Facebook using a product feed
  def products_count
    product_models.inject(0){|sum, model| sum + model.count}
  end

  # All application models that +act_as_facebook_product_item+
  # Override this method in your application if it fails to find all your product models
  def product_models
    all_models = if Rails.configuration.eager_load
      ApplicationRecord.subclasses
    else
      models = Dir.glob(File.join(Rails.root, "app/models/*.rb")).map do |file|
        begin
          basename = File.basename(file, '.rb').camelize.constantize
        rescue NameError
          nil
        end
      end
      models.compact
    end
    all_models.select{|klass| klass.respond_to? :facebook_product_item_mapping}
  end

  # Sample of product items that are exported to Facebook using a product feed
  def product_samples(count = 20, models = product_models)
    return [] if models.empty?
    limit = [count / models.count, 1].max
    models.map{|model| model.where(id: model.ids.sample(limit))}.flatten
  end

  def fb_default_url_options
    if !Rails.application.routes.default_url_options.try(:empty?)
      Rails.application.routes.default_url_options
    elsif not Rails.application.config.action_controller.default_url_options.try(:empty?)
      Rails.application.config.action_controller.default_url_options
    end
  end

  def fb_root_url(options = fb_default_url_options)
    protocol, host, port = options[:protocol], options[:host], options[:port]
    if options[:host]
      parts = host.split(/:\/\//)
      if parts.count > 1
        protocol = parts[0]
        host = parts[1]
      end
      parts = host.split(/:/)
      if parts.count > 1
        host = parts[0]
        port = parts[1]
      end
    end
    protocol ||= "http"
    host.chomp! '/'
    url = "#{protocol}://#{host}"
    url = "#{url}:#{port}" if port
    url
  end

  include FacebookPixelHelper
end