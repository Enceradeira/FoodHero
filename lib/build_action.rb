require 'colorize'

class BuildAction
  def self.execute!(cmd)
    puts cmd.bold
    result = system(cmd)
    unless result
      raise StandardError.new 'build aborted!'
    end
  end
end