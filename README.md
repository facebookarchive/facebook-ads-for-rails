** THIS REPO HAS BEEN ARCHIVED AND IS NO LONGER BEING ACTIVELY MAINTAINED **

# Facebook-ads

Facebook-ads gem makes it easy to advertise e-commerce products on Facebook. 
It helps to generate product feed and to install Facebook pixel on the website.     

## Installation

### 1. Adding gem dependency
Add this line to your application's Gemfile:

```ruby
gem 'ads'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install facebook-ads
```

### 2. Setting up product model(s)

Add `acts_as_facebook_product_item` to product models that you wish to advertise on Facebook.
Let's say your products are instances of a `SimpleProduct`:

```
class SimpleProduct < ApplicationRecord
end
```

`SimpleProduct` is has the following fields:
```
class CreateSimpleProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :simple_products do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :brand
      t.integer :price
      t.string :currency
      t.string :condition
      t.string :category
      t.string :availability
      t.string :link
      t.timestamps
    end
  end
end
```

`acts_as_facebook_product_item` defines how existing fields correspond to fields supported by Facebook Product Items.
In this example you should add the following code to your `SimpleProduct` class
 ```
 class SimpleProduct < ApplicationRecord
   acts_as_facebook_product_item google_product_category: :category, 
                                 image_link: :image
 end
```
Keys of the hash are Facebook product item fields. Values of the hash are names of the fields/methods
 defined in your model. When `facebook-ads` tries to export products to Facebook, it 
 transforms fields using the provided mapping. A field can be ommited in the mapping if 
   it has the same name as the corresponding field in Facebook Product Item.  

If you wish to run custom code to generate certain Facebook fields, define an instance method
and reference it in the mapping.

 ```
 class SimpleProduct < ApplicationRecord
   acts_as_facebook_product_item google_product_category: :category, 
                                 image_link: :image,
                                 currency: :my_currency 
   def my_currency
     category === "Japanese products" ? "JYN" : "USD"
   end
 end
```

The following list of fields is supported by `acts_as_facebook_product_item`: https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#required-fields
   
Note, that if your model is `SimpleProduct` then product feed will be generated using  
`SimpleProduct.all` query. Use `default_scope` to inlude only active products. In the following example 
only products that have `visible=true` are included to the product feed.   
 
 ```
  class SimpleProduct < ApplicationRecord
    acts_as_facebook_product_item ...
    default_scope -> {visible: true}
  end
 ```

### 3. Install Facebook pixel

Run generator:
```
rails generate install_facebook_pixel
```
This will add common pixel code into application layout and initialize storage for pixel id. 

### 4. Add setup button to admin interface
 
Add the following code to the admin page of your shop. See `open_facebook_ads_window` documentation for additional options. 
```
<%=open_facebook_ads_window "Connect to Facebook!"%>
```
This shows a button that opens a Facebook window with a dialog that lets user to set up integration with Faebook dynamic ads. 
 
### 5. Trigger custom pixel events

On step 3 you've only installed generic pixel code and `ViewContent` pixel fires. 
 You now need to report other events using helpers:
 
- `fb_view_content(product)` - page with `product` description is opened 
- `fb_add_to_cart(product)` - `product` was added to cart 
- `fb_initiate_checkout(products)` - user started checkout of `products` 
- `fb_add_payment_info(products)` - user added payment information for `products`
- `fb_purchase(products)` - user has purchased `products`

### 6. Authorize access to `FacebookSettingsController`
`FacebookSettingController` is used to store your Facebook-related settings to `settings` table.
It is generated on step #3 and by default doesn't check user permissions. 
You should give access only to users who see 'Connect to Facebook' button that is installed on step #4
This can be done by adding `before_action` hook:

```Ruby
class FacebookSettingsController < ApplicationController
  include Facebook::Ads::Settings
  before_action :check_admin
  
  def check_admin
    # Implement your authorization logic here 
  end
end
```

## License
The gem is available as open source under the terms of the Facebook Platform License: https://developers.facebook.com/policy/
