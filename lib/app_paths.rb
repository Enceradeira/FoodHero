module AppPaths
  def self.workspace_file
    @workspace_file ||=File.expand_path 'app/HelloWorldApp.xcworkspace'
  end

  def self.app_path
    @app_path ||= File.expand_path 'Applications/HelloWorldApp.app', self.dst_root
  end

  def self.dst_root
    dst_root ||= File.expand_path 'app/Build/Products/Current'
  end

  def self.scheme
    @scheme ||= 'HelloWorldApp'
  end
end
