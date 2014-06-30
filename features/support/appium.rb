require 'appium_lib'
require_relative '../../lib/app_paths'

# setup driver
caps = {
    caps: {
        platformName: 'iOS',
        versionNumber: '7.1',
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