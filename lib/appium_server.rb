class AppiumServer
  def self.is_running?
    pid != nil
  end

  def self.pid
    `ps -x -o pid,command | grep 'node\s.*appium$' | grep -v grep`.scan(/\d+/)[0]
  end


  def self.start
    if is_running?
      raise StandardError.new 'appium-server is already running'
    end
    system('appium &')
    unless is_running?
      raise StandardError.new "appium-server could't be started"
    end

  end

  def self.stop
    unless is_running?
      raise StandardError.new "appium-server is not running"
    end
    `kill #{pid}`
  end
end