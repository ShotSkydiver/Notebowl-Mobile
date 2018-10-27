source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!

pod 'HTTPStatusCodes', '~> 3.2.0'

    target 'Notebowl Mobile' do
        pod 'Kingfisher'
        pod 'ObjectMapper'
        pod 'FaveButton', :git => 'https://github.com/ShotSkydiver/fave-button', :branch => 'swift-4.2'
        pod 'HGPlaceholders', :git => 'https://github.com/ShotSkydiver/HGPlaceholders', :branch => 'swift-4.2'
        pod 'Bugsnag'
        pod 'InputBarAccessoryView'
        pod 'DeckTransition', '~> 2.0'
        pod 'MMUploadImage', :git => 'https://github.com/ShotSkydiver/UploadImage', :branch => 'swift-4.2'
        pod 'Haptica'
        pod 'FeedbackSlack', :git => 'https://github.com/ShotSkydiver/SlackFeedback'
        pod 'Tamamushi', :git => 'https://github.com/ShotSkydiver/Tamamushi'
        pod 'Socket.IO-Client-Swift', :git => 'https://github.com/socketio/socket.io-client-swift.git', :branch => 'development'
        pod 'YPImagePicker', :git => 'https://github.com/ShotSkydiver/YPImagePicker'
        pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :branch => 'develop'
        pod 'Hue', :git => 'https://github.com/hyperoslo/Hue.git'
        pod 'Cache'
        pod 'Imaginary'
        pod 'Lightbox'
        pod 'PKHUD'
        pod 'Siren'
        pod 'SwiftDate'
        pod 'GSKStretchyHeaderView'
        pod 'SwiftyBeaver'
        pod 'Branch'
        pod 'URLPatterns'
    end

    target 'NotebowlMobileUITests' do
        #inherit! :search_paths
        pod 'SimulatorStatusMagic'
        pod 'AutoMate'
    end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            # config.build_settings['ARCHS'] = 'arm64'
        end
    end
end
