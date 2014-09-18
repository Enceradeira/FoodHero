require 'colorize'
require 'cucumber/rake/task'
require 'nokogiri'
require_relative 'lib/app_paths'
require_relative 'lib/build_action'
require_relative 'lib/x_code_build_action'
require_relative 'lib/appium_server'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty --tags ~@ignore}
end

task :notify_build_succeeded do
  puts '*** CHECKLIST *********'.yellow.bold
  puts ' Did you hear the sound playing?'.yellow.bold

  puts '\n If CHECKLIST OK then all is OK'.green
  puts '*** BUILD SUCCEEDED ***'.green.bold
end

desc 'Opens XCode'
task :xcode do
  `open #{AppPaths.workspace_file}`
end

desc 'Prepare iOS-Simulator for tests'
task :prepare_iOS_simulator do
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.gpx(:version => '1.1', :creator => 'JJ') {
      xml.wpt(:lat => "52.631944", :lon => "1.298889")
    }
  end

  File.open('app/FoodHero/simulator_gps_coordinates.gpx', 'w') do |file|
    file.write(builder.to_xml)
  end

end

desc 'Clean the build'
task :clean do
  XCodeBuildAction.new(:clean).execute!
  BuildAction.execute!("rm -r -f #{AppPaths.dst_root}")
end

desc 'Run XCode unit-tests'
task :xc_unit_tests => [:prepare_iOS_simulator] do
  XCodeBuildAction.new(:test).execute!
end

desc 'Run Cucumber acceptance-tests'
task :acceptance_tests => [:check_appium_server, :prepare_iOS_simulator, :install, :cucumber] do
end

desc 'Build everything'
task :build do
  XCodeBuildAction.new(:build).execute!
end

desc 'Install build'
task :install do
  XCodeBuildAction.new(:install).execute!
end

desc 'Run all tests'
task :test => [:clean, :check_appium_server, :xc_unit_tests, :acceptance_tests, :notify_build_succeeded] do
end

desc 'checks appium-server'
task :check_appium_server do
  unless AppiumServer.is_running?
    message = "Appium-Server is not running. Start Appium-Server with 'appium'"
    puts message.red.bold
    raise StandardError.new message
  end
end

task :default => [:test] do
end

