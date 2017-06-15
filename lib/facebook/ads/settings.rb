# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

module Facebook
  module Ads

    # +SettingsUpdater+ module is included in settings controller to enable persisting of Facebook settings
    module SettingsUpdater
      # Persists :merchant_settings_id, :catalog_id, :pixel_id
      def update_settings
        @dia_settings = Setting.first || Setting.create
        render nothing: true, status: 200 if @dia_settings.update(setting_params(params))
      end

      private

      def setting_params params
        params.require(:settings).permit(:merchant_settings_id, :catalog_id, :pixel_id)
      end
    end
  end
end