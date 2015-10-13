require 'colorize'
require 'cucumber/rake/task'
require 'nokogiri'
require_relative 'lib/app_paths'
require_relative 'lib/build_action'
require_relative 'lib/x_code_build_action'
require_relative 'lib/food_hero_info_p_list'
require_relative 'lib/app_version'

Cucumber::Rake::Task.new(:cucumber_integration) do |t|
  t.cucumber_opts = %w{--format pretty --tags ~@ignore --tags ~@smoke_test}
end

Cucumber::Rake::Task.new(:cucumber_smoke_tests) do |t|
  t.cucumber_opts = %w{--format pretty --tags ~@ignore --tags @smoke_test}
end

task :notify_build_succeeded do
  puts '*** BUILD SUCCEEDED ***'.green.bold
end

desc 'Prints a checklist for tests that must be checked manually'
task :print_checklist do
  puts '*** CHECKLIST *********'.yellow
  puts ' Does the microphone work?'.yellow.bold
  puts ' Are Twitter/FB postings correctly formatted?'.yellow.bold
  puts ' Does sending email work from conversation->share'.yellow.bold
  puts ' Does sending email work from conversation->like (bubble) ...'.yellow.bold
  puts ' Does sending email work from help->feedback'.yellow.bold

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
task :clean => [:stop_appium, :stop_web_envs] do
  XCodeBuildAction.new(:clean).execute!('FoodHero')
  XCodeBuildAction.new(:clean).execute!('FoodHeroTests')
  XCodeBuildAction.new(:clean).execute!('FoodHeroIntegrationsTests')
  BuildAction.execute!("rm -r -f #{AppPaths.build_path}")
end

desc 'Run XCode unit-tests'
task :xc_unit_tests => [:prepare_iOS_simulator] do
  XCodeBuildAction.new(:test).execute!('FoodHeroTests')
end

desc 'Run XCode integration-tests'
task :xc_integration_tests => [:prepare_iOS_simulator, :start_web_integration_env] do
  XCodeBuildAction.new(:test).execute!('FoodHeroIntegrationsTests')
end

desc 'Run Acceptance-tests'
task :acceptance_tests => [:start_appium, :prepare_iOS_simulator, :start_web_integration_env, :cucumber_integration] do
end

desc 'Run Smoke-tests'
task :smoke_tests => [:cucumber_smoke_tests]do
end

desc 'Build everything'
task :build do
  XCodeBuildAction.new(:build).execute!('FoodHero')
end

desc 'Runs all app tests (without acceptance)'
task :app_tests => [:clean, :xc_unit_tests, :xc_integration_tests, :notify_build_succeeded] do
end

desc 'Run all web tests'
task :web_tests do
  BuildAction.execute!('rvm in ./web do rake')
end

desc 'Deploys the web'
task :deploy_web do
  BuildAction.execute!('rvm in ./web do rake deploy')
end

desc 'Start web integration environment (localhost:3001)'
task :start_web_integration_env do
  BuildAction.execute!('rvm in ./web do rake start_integration_env')
end

desc 'Start web development environment (localhost:3000)'
task :start_web_development_env do
  BuildAction.execute!('rvm in ./web do rake start_development_env')
end

desc 'Stop web environments'
task :stop_web_envs do
  BuildAction.execute!('rvm in ./web do rake stop_envs')
end

desc 'Starts appium'
task :start_appium do
  fork do
    `appium`
  end
  sleep 3
end

desc 'Stops appium'
task :stop_appium do
  `ps | grep -e '.*/appium$'| awk '{print "kill " $1}' | sh`
end

desc 'Runs the deployment pipeline up to the acceptance-tests'
task :up_to_acceptance_tests => [:app_tests, :web_tests, :acceptance_tests, :print_checklist, :notify_build_succeeded] do
end

desc 'Runs the deployment pipeline up to smoke-tests'
task :up_to_smoke_tests => [:publish, :smoke_tests, :notify_build_succeeded] do
end

desc 'increments the app/web version'
task :increment_version do
  AppVersion.build = AppVersion.build + 1
  FoodHeroInfoPList.cFBundleShortVersionString = AppVersion.version
  FoodHeroInfoPList.cFBundleVersion = AppVersion.build
end

desc 'checks that the working directory is clean'
task :check_git_dir_clean do
  found = `git status | grep -c 'directory clean'`
  unless found == "1\n"
    raise StandardError.new 'git working dir is NOT clean.'
  end

  found = `cd web && git status | grep -c 'directory clean' && cd ..`
  unless found == "1\n"
    raise StandardError.new 'git working dir is NOT clean.'
  end
end

desc 'commits the archive and creates a version tag'
task :commit_version do
  version = "V#{AppVersion.version}.#{AppVersion.build}"
  `git add .`
  `git commit -m "#{version} added"`
  `git tag #{version}`
  `cd web && git tag #{version} && cd ..`
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
task :publish_WITH_ITUNES_ERROR => [:check_git_dir_clean, :increment_version, :archive_app, :commit_version, :check_git_dir_clean, :upload_app, :deploy_web] do

end

desc 'Splits :publish task to prevent iTunesConnect error: Invalid Swift Support'
task :publish_workaround1 => [:check_git_dir_clean, :increment_version, :archive_app] do
  `open ./#{AppPaths.archive_path}/FoodHero.xcarchive`
  puts "\n NOW manually create the file ./#{AppPaths.archive_path}/FoodHero.ipa".green
  puts "\t\tand then run 'up_to_publish_workaround2'"
end

desc 'Splits :publish task to prevent iTunesConnect error: Invalid Swift Support'
task :up_to_publish_workaround2 => [:commit_version, :check_git_dir_clean, :upload_app, :deploy_web, :smoke_tests, :notify_build_succeeded] do

end


task :default => [:up_to_acceptance_tests] do
end

