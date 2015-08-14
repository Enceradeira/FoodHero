require 'appium_lib'
require_relative '../../lib/app_paths'
require_relative 'bubble_cache'

# Promote appium methods into the cucumber world
class AppiumWorld
  class << self
    def setup_driver
      # setup driver
      caps = {
          caps: {
              platformName: 'iOS',
              platformVersion: AppPaths.version,
              deviceName: 'iPhone 5s', # one from 'instruments -s devices'
              #locationServicesEnabled: false,
              #locationServicesAuthorized: false,
              #autoAcceptAlerts: false,
              #noReset: false,
              # app: AppPaths.app_path,
              app: AppPaths.build_path, # WORKAROUND: FoodHero.app (with swiftcode) is sometimes invalid when copied from above AppPaths.app_path
              processArguments: '-environment=Integration'
          },
          appium_lib: {
              sauce_username: nil, # don't run on Sauce
              sauce_access_key: nil
          }
      }
      @driver = Appium::Driver.new(caps)
      @driver.start_driver
      @driver.no_wait
      @driver
    end

    def quit_driver
      @driver.driver_quit
    end
  end
end

# BubbleCache
module BubbleCacheWorld
  class << self;
    attr_accessor :cache;
  end

  def bubbles
    BubbleCacheWorld.cache.bubbles
  end
end

# extend cucumber steps
World(BubbleCacheWorld) do
  AppiumWorld.new
end

# let cucumber control driver
Before('@app') do
  driver = AppiumWorld.setup_driver
  Appium.promote_appium_methods AppiumWorld

  BubbleCacheWorld.cache = BubbleCache.new(driver)
  BubbleCacheWorld.cache.reset
end

After('@app') do
  AppiumWorld.quit_driver
end