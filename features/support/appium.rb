require 'appium_lib'
require_relative '../../lib/app_paths'

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
        app: AppPaths.app_path,
    },
    appium_lib: {
        sauce_username: nil, # don't run on Sauce
        sauce_access_key: nil
    }
}
driver = Appium::Driver.new(caps)

# Promote appium methods into the cucumber world
class AppiumWorld
end
Appium.promote_appium_methods AppiumWorld
World do
  AppiumWorld.new
end

# let cucumber control driver
Before do
  driver.start_driver
  driver.no_wait
end
After do
  driver.driver_quit
end