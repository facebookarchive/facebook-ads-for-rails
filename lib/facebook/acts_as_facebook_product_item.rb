# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

module Facebook
  module Ads

    # Fields required by Facebook product feed format:
    # https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#required-fields
    PRODUCT_ITEM_REQUIRED_FIELDS = [
        :id,
        :availability,
        :condition,
        :description,
        :image_link,
        :link,
        :title,
        :price,
        :price_currency, # required only by plugin
    ]

    # At least one of +gtin+, +mpn+, +brand+ fields should be defined:
    # https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#required-fields
    PRODUCT_ID = [
        :gtin,
        :mpn,
        :brand,
    ]

    # See optional fields:
    # https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#required-fields
    PRODUCT_ITEM_OPTIONAL_FIELDS = [
        :additional_image_link,
        :age_group,
        :applink,
        :google_product_category,
        :color,
        :commerce_product_item_id,
        :custom_label_0,
        :custom_label_1,
        :custom_label_2,
        :custom_label_3,
        :custom_label_4,
        :expiration_date,
        :gender,
        :inventory,
        :material,
        :name,
        :pattern,
        :price_amount,
        :product_type,
        :retailer_id,
        :sale_price,
        :sale_price_amount,
        :sale_price_currency,
        :sale_price_start_date,
        :sale_price_end_date,
        :shipping,
        :shipping_country,
        :shipping_price_currency,
        :shipping_region,
        :shipping_service,
        :shipping_price_value,
        :shipping_weight_value,
        :shipping_weight_unit,
        :short_description,
        :size,
        :start_date,
        :variant,
        :variant_label,
        :variant_options,
        :variant_value,
        :videos,
        :retailer_group_id,
        :webitemid,
    ]

    # See 'Product Deep Links' https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#required-fields
    PRODUCT_ITEM_APP_LINK_FIELDS = [
        :ios_url,
        :ios_app_store_id,
        :ios_app_name,
        :iphone_url,
        :iphone_app_store_id,
        :iphone_app_name,
        :ipad_url,
        :ipad_app_store_id,
        :ipad_app_name,
        :android_url,
        :android_package,
        :android_app_name,
        :windows_phone_url,
        :windows_phone_app_id,
        :windows_phone_app_name,
        :web_should_fallback,
    ]

    PRODUCT_ITEM_ALL_OPTIONAL_FIELDS = PRODUCT_ITEM_OPTIONAL_FIELDS + PRODUCT_ITEM_APP_LINK_FIELDS + PRODUCT_ID

    PRODUCT_ITEM_FIELDS = PRODUCT_ITEM_REQUIRED_FIELDS + PRODUCT_ITEM_ALL_OPTIONAL_FIELDS

    module ActsAsFacebookProductItem
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods

        # Marks model to be used to generate Facebook product feeds and to track Facebook pixel events
        # +mapping+ argument maps fields defined in Facebook feed format (https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#required-fields)
        # into names of fields/instance methods of the model.
        #
        # ==== Example
        #
        #
        #  class MyProduct < ApplicationRecord
        #    acts_as_facebook_product_item description: :desc,                # :description is mapped to an existing field :desc
        #                                  availability: :fb_availability,    # :availability is calculated 'on the fly' in fb_availability function
        #                                  link: :gen_link,                   # :link is calculated 'on the fly'
        #                                  image_link: :img,                  # :image_link is mapped to an existing field :img
        #                                  title: :title                      # Redundant declaration, can be ommited
        #
        #    def gen_link
        #      Rails.application.routes.url_helpers.my_product_url(self, host: "letonamore.ru:13243")
        #    end
        #
        #    def fb_availability
        #      availability ? "in stock" : "out of stock"
        #    end
        #
        #    def price_currency
        #      "USD"
        #    end
        #  end
        #
        # All fields that have the same name in Facebook feed and in the model can be ommited in +acts_as_facebook_product_item+ call
        # Note that all +PRODUCT_ITEM_REQUIRED_FIELDS+ fields *must* either present in acts_as_facebook_product_item declaration or
        # in the list of model fields/instance methods
        #
        def acts_as_facebook_product_item(mapping = {})
          cattr_accessor :facebook_product_item_mapping
          extra_fields = mapping.keys - PRODUCT_ITEM_FIELDS
          raise ArgumentError, "Provided field names #{extra_fields} are not supported. List of supported fields: #{PRODUCT_ITEM_FIELDS}" unless extra_fields.empty?
          self.facebook_product_item_mapping = PRODUCT_ITEM_FIELDS.map { |field| [field, field] }.to_h.merge(mapping)
          include Facebook::Ads::ActsAsFacebookProductItem::LocalInstanceMethods
        end
      end

      def convert_fields(result, obj, fields, required)
        fields.map do |fb_field|
          obj_field = obj.facebook_product_item_mapping[fb_field]
          if self.respond_to? obj_field
            result[fb_field] = obj.send(obj_field)
          else
            raise RuntimeError, "Required field is missing #{obj.class.name}.#{fb_field.to_s}" if required
          end
        end
      end

      module LocalInstanceMethods
        # Used to generate representation of the model instance compatible with Facebook feed format.
        #
        #   (rails console)> MyProduct.first.to_facebook_product_item
        #   MyProduct Load (0.9ms)  SELECT  "my_products".* FROM "my_products" ORDER BY "my_products"."id" ASC LIMIT ?  [["LIMIT", 1]]
        #   => {:gtin=>nil, :brand=>"SOCIETY", :id=>"MyProduct-1", :availability=>"in stock", :condition=>"new", :description=>"This product was hand made just for You. We take pride in making one of a kind, unique, products that fit and feel amazing. All garments are printed with eco-friendly water based inks for the softest possible touch. We hope you enjoy this product as much as we enjoyed creating it for you. Model info: 6'0 / 165 lbs / size Medium Premium sublimation tank. 51% cotton/ 49% poly. Machine washable.\"", :image_link=>"https://cdn.shopify.com/s/files/1/0158/3516/products/DSC_0035.5_bfca2d2e-5aeb-4368-b062-aac832e80d4c_large.jpg?v=1394756249", :link=>"http://letonamore.ru:13243/my_products/1", :title=>"Absent", :price=>34, :price_currency=>"USD", :google_product_category=>"Apparel & Accessories > Clothing"}
        def to_facebook_product_item
          result = {}
          convert_fields(result, self, PRODUCT_ID, false)
          raise RuntimeError, "Expected at least one of #{PRODUCT_ID.inspect} fields in product #{self.class.name}" if result.empty?
          convert_fields(result, self, PRODUCT_ITEM_REQUIRED_FIELDS, true)
          convert_fields(result, self, PRODUCT_ITEM_ALL_OPTIONAL_FIELDS, false)
          result[:id] = "#{self.class.name}-#{self.id}"
          result
        end
      end
    end
  end
end
