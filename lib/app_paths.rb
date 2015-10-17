module AppPaths
  def self.workspace_file
    @workspace_file ||=File.expand_path 'app/FoodHero.xcworkspace'
  end

=begin
  def self.app_path
    @app_path ||= File.expand_path 'Applications/FoodHero.app', self.dst_root
  end
=end

  def self.build_path
    @build_path ||= '~/Library/Developer/Xcode/DerivedData/FoodHero-goqmcyugajoinecnvixklnogussq/Build/Products/Debug-iphonesimulator'
  end

  def self.app_bin
    'FoodHero.app'
  end

  def self.file_path_app_bin
    File.join(self.build_path,self.app_bin)
  end

=begin
  def self.dst_root
    @dst_root ||= File.expand_path 'app/Build/Products/Current'
  end
=end

  def self.version
    '9.0'
  end

  def self.archive_path
    'app/archives'
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

  def self.device
    'iPhone 6s'
  end

  def self.export_options_plist
    'app/FoodHero/exportOptionPList.plist'
  end
end
