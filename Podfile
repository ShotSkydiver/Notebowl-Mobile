source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!

pod 'HTTPStatusCodes', '~> 3.2.0'

    target 'Notebowl Mobile' do
        pod 'Kingfisher', '~> 4.0'
        pod 'ObjectMapper', '~> 3.1'
        pod 'FaveButton', :git => 'https://github.com/ShotSkydiver/fave-button', :branch => 'swift-4.2'
        pod 'HGPlaceholders', :git => 'https://github.com/ShotSkydiver/HGPlaceholders', :branch => 'swift-4.2'
        pod 'Bugsnag'
        pod 'InputBarAccessoryView'
        pod 'DeckTransition', '~> 2.0'
        pod 'MMUploadImage', :git => 'https://github.com/ShotSkydiver/UploadImage', :branch => 'swift-4.2'
        pod 'FaceAware', :git => 'https://github.com/BeauNouvelle/FaceAware.git'
        pod 'Haptica', :git => 'https://github.com/efremidze/Haptica', :branch => 'swift-4.2'
        pod 'FeedbackSlack', :git => 'https://github.com/ShotSkydiver/SlackFeedback'
        pod 'Tamamushi', :git => 'https://github.com/ShotSkydiver/Tamamushi'
        pod 'Socket.IO-Client-Swift', '~> 13.1.0'
        pod 'SteviaLayout', '~> 4.4.0'
        pod 'PryntTrimmerView', :git => 'https://github.com/HHK1/PryntTrimmerView'
        pod 'YPImagePicker', :git => 'https://github.com/ShotSkydiver/YPImagePicker', :branch => 'Swift42'
        pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :branch => 'develop'
        pod 'Hue', :git => 'https://github.com/hyperoslo/Hue.git', :commit => '8a3457a7cb5e9f270edb81b0d5045529f2f08ccb'
        pod 'Cache', :git => 'https://github.com/hyperoslo/Cache.git', :commit => '1664e8a1d6807ea7267c3aaf590024c742bb17ae'
        pod 'Imaginary', :git => 'https://github.com/ShotSkydiver/Imaginary', :branch => 'swift-4.2'
        pod 'Lightbox', :git => 'https://github.com/ShotSkydiver/Lightbox', :branch => 'swift-4.2'
        pod 'PKHUD', :git => 'https://github.com/edisonlsm/PKHUD', :branch => 'swift-4.2'
        pod 'Siren'
        pod 'SwiftDate', '~> 5.0'
        pod 'AutoMate-AppBuddy'
        pod 'GSKStretchyHeaderView'
    end

    target 'NotebowlMobileUITests' do
        #inherit! :search_paths
        pod 'SimulatorStatusMagic', :configurations => ['Debug']
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
            config.build_settings['ARCHS'] = 'arm64'
        end
    end
end
