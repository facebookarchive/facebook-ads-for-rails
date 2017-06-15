# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

class ApplicationRecord < ActiveRecord::Base
  include Facebook::Ads::ActsAsFacebookProductItem

  self.abstract_class = true
end
