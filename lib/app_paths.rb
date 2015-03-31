module AppPaths
  def self.workspace_file
    @workspace_file ||=File.expand_path 'app/FoodHero.xcworkspace'
  end

  def self.app_path
    @app_path ||= File.expand_path 'Applications/FoodHero.app', self.dst_root
  end

  def self.build_path
    @build_path ||= '~/Library/Developer/Xcode/DerivedData/FoodHero-goqmcyugajoinecnvixklnogussq/Build/Products/Debug-iphonesimulator/FoodHero.app'
  end

  def self.dst_root
    dst_root ||= File.expand_path 'app/Build/Products/Current'
  end

  def self.version
    '8.2'
  end

end
