platform :ios, '11.0'
use_frameworks!

pod 'HTTPStatusCodes', '~> 3.2.0'

    target 'Notebowl Mobile' do
        pod 'Kingfisher', '4.9.0'
        pod 'ObjectMapper', '~> 3.1'
        pod 'FaveButton', :git => 'https://github.com/ShotSkydiver/fave-button'
        pod 'HGPlaceholders', :git => 'https://github.com/ShotSkydiver/HGPlaceholders'
        pod 'Bugsnag'
        pod 'InputBarAccessoryView', '3.0.1'
        pod 'DeckTransition', '2.0'
        pod 'MMUploadImage', :git => 'https://github.com/ShotSkydiver/UploadImage.git'
        pod 'FaceAware', :git => 'https://github.com/BeauNouvelle/FaceAware.git'
        pod 'Haptica'
        pod 'FeedbackSlack', :git => 'https://github.com/ShotSkydiver/SlackFeedback'
        pod 'Tamamushi', :git => 'https://github.com/ShotSkydiver/Tamamushi'
        pod 'Socket.IO-Client-Swift', '~> 13.1.0'
        pod 'YPImagePicker', :git => 'https://github.com/ShotSkydiver/YPImagePicker'
        pod 'SwipeCellKit', '2.4.3'
        pod 'Lightbox'
        pod 'PKHUD', '~> 5.0'
        pod 'Siren', '3.4.3'
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
