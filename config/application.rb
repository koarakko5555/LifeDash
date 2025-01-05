require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module TechlogApp
  class Application < Rails::Application
    config.load_defaults 7.0

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end

    config.i18n.default_locale = :ja
    # タイムゾーンを日本標準時に設定
    config.time_zone = 'Tokyo'
    # データベースもタイムゾーンを統一
    config.active_record.default_timezone = :local
  end
end
