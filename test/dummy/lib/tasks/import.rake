# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

task import_tsv: :environment do
  require 'csv'
  ActiveRecord::Base.transaction do
    SimpleProduct.destroy_all
    CSV.read(ENV['file'], headers: true).each do |l|
      SimpleProduct.find_or_initialize_by(image: l['image_link']).update_attributes(
                      title: l['title'], description: l['description'], price: l['price'], image: l['image_link'],
                      brand: l['brand'], condition: l['condition'], currency: "USD",
                      availability: l['availability'], category: l['google_product_category'], link: l['link']
      )
    end
  end
end