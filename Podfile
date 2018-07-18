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
    pod 'FaceAware', :git => 'https://github.com/BeauNouvelle/FaceAware.git'
    pod 'Haptica'
    pod 'ButtonProgressBar-iOS'
    pod 'FeedbackSlack', :git => 'https://github.com/ShotSkydiver/SlackFeedback'
    pod 'Tamamushi'
    pod 'Socket.IO-Client-Swift', '~> 13.1.0'
    pod 'YPImagePicker', :git => 'https://github.com/ShotSkydiver/YPImagePicker'
    pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :branch => 'develop'
    pod 'Lightbox'
    pod 'HTTPStatusCodes', '~> 3.2.0'
    pod 'AcknowList'
    # pod 'MBProgressHUD', '~> 1.1.0'
    pod 'PKHUD', '~> 5.0'
    # pod 'Reveal-SDK', :configurations => ['Debug']
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['ARCHS'] = 'arm64'
        end
    end
end
