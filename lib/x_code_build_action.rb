require_relative 'build_action'

class XCodeBuildAction
  def initialize(build_action)
    @build_action = build_action
  end

  def execute!(scheme)
    BuildAction.execute!("xcodebuild #{@build_action} -sdk iphonesimulator -destination 'platform=iOS Simulator,name=#{AppPaths.device},OS=#{AppPaths.version}'  -workspace '#{AppPaths.workspace_file}' -scheme '#{scheme}' ONLY_ACTIVE_ARCH=NO")
  end

  def archive!(scheme)
    BuildAction.execute!("xcodebuild -scheme '#{scheme}' archive -archivePath '#{AppPaths.archive_path}/#{scheme}.xcarchive' -workspace '#{AppPaths.workspace_file}'")
  end

  def export_archive!(scheme)
    BuildAction.execute!("xcodebuild -exportArchive -archivePath '#{AppPaths.archive_path}/#{scheme}.xcarchive' -exportPath '#{AppPaths.archive_path}/#{scheme}.ipa' -exportOptionsPlist '#{AppPaths.export_options_plist}' ")
  end
end
