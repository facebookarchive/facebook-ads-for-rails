# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

# Installs facebook-ads plugin
class InstallFacebookAdsGenerator < Rails::Generators::Base
  def install_pixel
    if File.exists? "#{Rails.root}/app/views/layouts/application.html.erb"
      inject_into_file 'app/views/layouts/application.html.erb', before: "</head>" do
        "  <%=init_facebook_pixel%>\n"
      end
    end
  end

  # enable acts_as_facebook_product_item for all models
  def enable_acts_as_facebook_product_item
    if File.exists? "#{Rails.root}/app/models/application_record.rb"
      inject_into_file 'app/models/application_record.rb', after: "class ApplicationRecord < ActiveRecord::Base\n" do
        "  include Facebook::Ads::ActsAsFacebookProductItem\n"
      end
    end
  end

  # generates migration for settings table
  def generate_migration
    rake "facebook_ads_engine:install:migrations"
    rake "db:migrate"
  end

  def add_facebook_settings_controller
    generate 'controller', 'facebook_settings'
    inject_into_file 'app/controllers/facebook_settings_controller.rb', before: 'end' do
      "  include Facebook::Ads::Settings\n" +
      "  # TODO insert your authorization code here\n"
    end
    route "post '/facebook/update_settings', to: 'facebook_settings#update_settings'"
  end
end