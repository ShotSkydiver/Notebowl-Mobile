platform :ios, '11.0'

target 'Notebowl Mobile' do
  use_frameworks!

    pod 'Kingfisher', '~> 4.0'
    pod 'ObjectMapper', '~> 3.1'
    pod 'FaveButton', :git => 'https://github.com/ShotSkydiver/fave-button'
    pod 'HGPlaceholders'
    pod 'Bugsnag'
    pod 'InputBarAccessoryView'
    pod 'DeckTransition', '~> 2.0'
    pod 'MMUploadImage'
    pod 'FaceAware'
    pod 'Haptica'
    pod 'ButtonProgressBar-iOS'
    pod 'FeedbackSlack', :git => 'https://github.com/ShotSkydiver/SlackFeedback'
    pod 'RLBAlertsPickers', :git => 'https://github.com/ShotSkydiver/Alerts-Pickers'
    pod 'Tamamushi'
    pod 'Socket.IO-Client-Swift', '~> 13.1.0'
    pod 'NVActivityIndicatorView'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        # add this line
        target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
