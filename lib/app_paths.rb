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
    '8.4'
  end

  def self.archive_path
    'app/archives'
  end

  def self.provisioning_profile
    'XC: uk.co.jennius.FoodHero'
  end

  def self.altool_path
    '/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool'
  end

  def self.i_tunes_connect_user
    'jorg.jenni@jennius.co.uk'
  end

  def self.i_tunes_connect_pwd
    'L779XWTjB23e'
  end

  def self.current_version

  end

end
