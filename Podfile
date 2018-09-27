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
        pod 'Haptica', :git => 'https://github.com/efremidze/Haptica', :branch => 'swift-4.2'
        pod 'FeedbackSlack', :git => 'https://github.com/ShotSkydiver/SlackFeedback'
        pod 'Tamamushi', :git => 'https://github.com/ShotSkydiver/Tamamushi'
        pod 'Socket.IO-Client-Swift', :git => 'https://github.com/socketio/socket.io-client-swift.git', :branch => 'development'
        pod 'SteviaLayout', '~> 4.4.0'
        pod 'PryntTrimmerView', :git => 'https://github.com/HHK1/PryntTrimmerView', :tag => '3.0.0-beta.1'
        pod 'YPImagePicker', :git => 'https://github.com/ShotSkydiver/YPImagePicker', :branch => 'Swift42'
        pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :branch => 'develop'
        pod 'Hue', :git => 'https://github.com/hyperoslo/Hue.git'
        pod 'Cache', :git => 'https://github.com/hyperoslo/Cache.git'
        pod 'Imaginary', :git => 'https://github.com/hyperoslo/Imaginary.git'
        pod 'Lightbox', :git => 'https://github.com/ShotSkydiver/Lightbox.git'
        pod 'PKHUD', :git => 'https://github.com/ShotSkydiver/PKHUD.git'
        pod 'Siren'
        pod 'SwiftDate'
        pod 'GSKStretchyHeaderView'
        pod 'SwiftyBeaver'
    end

    target 'NotebowlMobileUITests' do
        #inherit! :search_paths
        pod 'SimulatorStatusMagic', :git => 'https://github.com/shinydevelopment/SimulatorStatusMagic.git', :commit => '84099c5fbdb340d744d467b955642ebd9f2b41da'
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
