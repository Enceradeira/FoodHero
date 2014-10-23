module AppPaths
  def self.workspace_file
    @workspace_file ||=File.expand_path 'app/FoodHero.xcworkspace'
  end

  def self.app_path
    @app_path ||= File.expand_path 'Applications/FoodHero.app', self.dst_root
  end

  def self.dst_root
    dst_root ||= File.expand_path 'app/Build/Products/Current'
  end

  def self.version
    '8.1'
  end

end
