require 'appium_lib'
require_relative '../../lib/app_paths'
require_relative 'bubble_cache'

# Promote appium methods into the cucumber world
class AppiumWorld
  class << self
    def setup_driver(simulate_slowness)
      # setup driver
      caps = {
          caps: {
              platformName: 'iOS',
              platformVersion: AppPaths.version,
              deviceName: AppPaths.device, # one from 'instruments -s devices'
              #locationServicesEnabled: false,
              #locationServicesAuthorized: false,
              #autoAcceptAlerts: false,
              #noReset: false,
              # app: AppPaths.app_path,
              app: AppPaths.file_path_app_bin, # WORKAROUND: FoodHero.app (with swiftcode) is sometimes invalid when copied from above AppPaths.app_path
              processArguments: "-environment=Integration -simulateSlowness=#{simulate_slowness}"
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

def promote_appium_world(driver)
  Appium.promote_appium_methods AppiumWorld

  BubbleCacheWorld.cache = BubbleCache.new(driver)
  BubbleCacheWorld.cache.reset
end

# let cucumber control driver
Before('@app','@simulateSlowness') do
  driver = AppiumWorld.setup_driver(true)
  promote_appium_world(driver)
end

Before('@app','~@simulateSlowness') do
  driver = AppiumWorld.setup_driver(false)
  promote_appium_world(driver)
end

After('@app') do
  AppiumWorld.quit_driver
end