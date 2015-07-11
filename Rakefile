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
  puts '*** BUILD SUCCEEDED ***'.green.bold
end

desc 'Prints a checklist for tests that must be checked manually'
task :print_checklist do
  puts '*** CHECKLIST *********'.yellow
  puts ' Does the microphone work?'.yellow.bold
  puts ' Are Twitter/FB postings correctly formatted?'.yellow.bold

  puts "\n If CHECKLIST is OK then all is OK".green
end

desc 'Opens XCode'
task :xcode do
  `open #{AppPaths.workspace_file}`
end

desc 'Prepare iOS-Simulator for tests'
task :prepare_iOS_simulator do
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.gpx(:version => '1.1', :creator => 'JJ') {
      xml.wpt(:lat => '51.507451', :lon => '-0.127742')
    }
  end

  File.open('app/FoodHero/simulator_gps_coordinates.gpx', 'w') do |file|
    file.write(builder.to_xml)
  end

end

desc 'Clean the build'
task :clean do
  XCodeBuildAction.new(:clean).execute!('FoodHero')
  XCodeBuildAction.new(:clean).execute!('FoodHeroTests')
  XCodeBuildAction.new(:clean).execute!('FoodHeroIntegrationsTests')
  BuildAction.execute!("rm -r -f #{AppPaths.dst_root}")
end

desc 'Run XCode unit-tests'
task :xc_unit_tests => [:prepare_iOS_simulator] do
  XCodeBuildAction.new(:test).execute!('FoodHeroTests')
end

desc 'Run XCode integration-tests'
task :xc_integration_tests => [:prepare_iOS_simulator] do
  XCodeBuildAction.new(:test).execute!('FoodHeroIntegrationsTests')
end

desc 'Run Cucumber acceptance-tests'
task :acceptance_tests => [:check_appium_server, :prepare_iOS_simulator, :install, :cucumber] do
end

desc 'Build everything'
task :build do
  XCodeBuildAction.new(:build).execute!('FoodHero')
end

desc 'Install build'
task :install do
  XCodeBuildAction.new(:install).execute!('FoodHero')
end

desc 'Runs all app tests (without acceptance)'
task :app_tests => [:clean, :xc_unit_tests, :xc_integration_tests, :notify_build_succeeded] do
end

desc 'Run all web tests (without acceptance)'
task :web_tests do
  BuildAction.execute!('rvm in ./web do rake')
end

desc 'Deploys the web'
task :deploy_web do
  BuildAction.execute!('rvm in ./web do rake deploy')
end

desc 'Run all tests'
task :test_all => [:clean, :check_appium_server, :xc_unit_tests, :xc_integration_tests, :web_tests, :acceptance_tests, :print_checklist, :notify_build_succeeded] do
end

desc 'checks appium-server'
task :check_appium_server do

  unless AppiumServer.is_running?
    message = "Appium-Server is not running. Start Appium-Server with 'appium'"
    puts message.red.bold
    raise StandardError.new message
  end

  #puts "CHECK APPIUM IS DISABLED!".yellow.bold
end

desc 'Creates an archive for app deployment'
task :archive_app do
  BuildAction.execute!("rm -r -f #{AppPaths.archive_path}")
  XCodeBuildAction.new(:archive).archive!('FoodHero')
  XCodeBuildAction.new(:export_archive!).export_archive!('FoodHero')
end

desc 'Uploads the latest build archive to iTunesConnect'
task :upload_app do
  BuildAction.execute!("'#{AppPaths.altool_path}' --upload-app -f ./#{AppPaths.archive_path}/FoodHero.ipa -u #{AppPaths.i_tunes_connect_user} -p #{AppPaths.i_tunes_connect_pwd}")
end

desc 'Tests the app creates, archive and uploads it to iTunesConnect, deploys web to Heroku'
task :publish => [:test_all, :archive_app, :upload_app, :deploy_web] do
end

task :default => [:test_all] do
end

