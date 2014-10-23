require_relative 'build_action'

class XCodeBuildAction
  def initialize(build_action)
    @build_action = build_action
  end

  def execute!(scheme)
    BuildAction.execute!("xcodebuild #{@build_action} -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 5s,OS=#{AppPaths.version}'  -workspace '#{AppPaths.workspace_file}' -scheme '#{scheme}' DSTROOT='#{AppPaths.dst_root}' ONLY_ACTIVE_ARCH=NO")
  end
end
