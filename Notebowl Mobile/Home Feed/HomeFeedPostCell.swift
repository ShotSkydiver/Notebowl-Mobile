//
//  HomeFeedPostCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/15/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import FaveButton
import Haptica
import ObjectMapper
import SocketIO
import SwipeCellKit
import Lightbox
import FaceAware
import PKHUD

class IndexedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    fileprivate var paginatedScroll: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard proposedContentOffset.x > 0 else {
            return CGPoint(x: 0, y: 0)
        }
        guard paginatedScroll == true else {
            return CGPoint(x: proposedContentOffset.x, y: 0)
        }
        guard let collectionView: UICollectionView = collectionView else {
            return CGPoint(x: proposedContentOffset.x, y: 0)
        }
        let collectionFrame = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        guard let layoutAttributes: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: collectionFrame) else {
            return CGPoint(x: proposedContentOffset.x, y: 0)
        }
        let collectionViewInsets: CGFloat = 10.0
        let proposedXCoordWithInsets = proposedContentOffset.x + collectionViewInsets
        
        var offsetCorrection: CGFloat = .greatestFiniteMagnitude
        layoutAttributes.filter { layoutAttribute -> Bool in
            layoutAttribute.representedElementCategory == .cell
            }.forEach { cellLayoutAttribute in
                let discardableScrollingElementsFrame: CGFloat = collectionView.contentOffset.x + (collectionView.frame.size.width / 2)
                if (cellLayoutAttribute.center.x <= discardableScrollingElementsFrame && velocity.x > 0) || (cellLayoutAttribute.center.x >= discardableScrollingElementsFrame && velocity.x < 0) {
                    return
                }
                if abs(cellLayoutAttribute.frame.origin.x - proposedXCoordWithInsets) < abs(offsetCorrection) {
                    offsetCorrection = cellLayoutAttribute.frame.origin.x - proposedXCoordWithInsets
                }
        }
        return CGPoint(x: proposedContentOffset.x + offsetCorrection, y: 0)
    }
}
class IndexedCollectionView: UICollectionView {
    var indexPath: IndexPath!
}

class HomeFeedPostCell: SwipeTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var designableView: DesignableView!
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var pinnedRibbon: UIImageView!
    @IBOutlet weak var userAvatarConstraint: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postComments: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var courseForPost: UILabel!
    @IBOutlet weak var collectionView: IndexedCollectionView!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var commentButton: FaveButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionFlowLayout: IndexedCollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameDateStackView: UIStackView!
    @IBOutlet weak var actionsStackView: UIStackView!
    
    var images = [UIImage]()
    var lightboxPhotos = [LightboxImage]()
    var postForCell: Post!
    var tempCount: Int?
    var collectionViewPaginatedScroll: Bool?
    var isValidTouch: Bool = true
    weak var parentController: HomeFeedViewController?
    
    weak var lightboxController: LightboxController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.accessibilityIdentifier = "IndexedCollectionView"
        collectionView.delegate = self
        collectionView.dataSource = self
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        collectionView.register(UINib(nibName: "IndexedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: IndexedCollectionViewCell.identifier)
        collectionViewPaginatedScroll = true
        collectionViewHeight.constant = 0.0
        userAvatarConstraint.constant = 12.0

        actionsStackView.setCustomSpacing(UIStackView.spacingUseSystem, after: commentButton)
        
        postContentTextView.wrapToContent()
        moreButton.setImage(UIImage(named: "more-vector")!.filled(withColor: .lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nameDateTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        nameDateStackView.addGestureRecognizer(tapGesture)
        userAvatar.addGestureRecognizer(tapGesture)
        
        likeButton.isHaptic = true
        likeButton.hapticType = .impact(.light)
        
        LightboxConfig.loadImage = {
            imageView, URL, completion in
            imageView.kf.setImage(with: URL, options: [.transition(ImageTransition.fade(0.3))], completionHandler: { (image, error, cacheType, URL) in
                if (error != nil) {
                    completion?(nil)
                }
                else {
                    TTLog.debug("lightbox loaded!")
                    completion?(image)
                }
            })
        }
        LightboxConfig.CloseButton.image = UIImage(named: "dismiss-vector")!.filled(withColor: UIColor.groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.DeleteButton.enabled = true
        LightboxConfig.DeleteButton.image = UIImage(named: "upload-vector")!.filled(withColor: UIColor.groupTableViewBackground).withRenderingMode(.alwaysOriginal)
        LightboxConfig.DeleteButton.text = ""
        LightboxConfig.PageIndicator.separatorColor = .groupTableViewBackground
        LightboxConfig.PageIndicator.textAttributes = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ]

        selectedBackgroundView?.backgroundColor = UIColor.cyan
    }

    @objc func nameDateTapped(_ sender: Any) {
        TTLog.debug("nameDate tapped!")
    }
    
    func configure(post: Post) {
        likeButton.addTarget(self, action: #selector(likeActionTriggered(_:)), for: UIControlEvents.touchUpInside)
        
        likeButton.setSelected(selected: post.likedByCurrentUser, animated: false)
        postLikes.text = (post.postLikes.isEmpty || post.postLikes == nil) ? " " : "\(post.postLikes.count)  "
        postComments.text = (post.postComments.isEmpty || post.postComments == nil) ? " " : "\(post.postComments.count)"
        
        if post.text == nil { postContentTextView.isHidden = true }
        else { postContentTextView.text = post.text! }
        
        if post.owner is Course { courseForPost.text = (post.owner as! Course).fullName }
        else if post.owner is Group { courseForPost.text = (post.owner as! Group).name }
 
        if post.editedAt != nil { (postedDate.text = post.createdAt.relativeFormat + " (edited)") }
        else { (postedDate.text = post.createdAt.relativeFormat) }
        
        designableView.backgroundColor = (post.pinned ? UIColor(hexString: "#fafafa") : UIColor(hexString: "#ffffff"))
        designableView.borderColor = (post.pinned ? UIColor(hexString: "#e1e1e1") : UIColor(hexString: "#e7e7e7"))
        designableView.borderWidth = (post.pinned ? 1.0 : 0.5)
        
        pinnedRibbon.isHidden = (post.pinned ? false : true)
        userAvatarConstraint.constant = (post.pinned ? 40.0 : 12.0)
        
        if post.isAnonymous {
            userName.text = "Anonymous"
            userAvatar.image = UIImage(named: "anonymous")
        }
        else if post.creator! == NBClient.shared.getCurrentUser() {
            userName.text = post.creator!.fullName
            userAvatar.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ])
        }
        else {
            userName.text = post.creator!.fullName
            userAvatar.kf.setImage(with: post.creator!.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                                ])
        }
        
        if lightboxPhotos.isEmpty {
            for attachment in post.attachments {
                let lightboxPhoto = LightboxImage(imageURL: attachment.getUrlForAvatar()!.absoluteURL)
                self.lightboxPhotos.append(lightboxPhoto)
            }
        }
        
        if (!post.attachments.isEmpty) && (post.attachments.first!.type != nil) {
            if (post.attachments.first!.type.contains("image")) {
                collectionViewHeight.constant = 100.0
            }
        }
        else {
            collectionViewHeight.constant = 0.0
        }
        self.postForCell = post
    }
    
    final override func layoutSubviews() {
        super.layoutSubviews()
        collectionFlowLayout.paginatedScroll = collectionViewPaginatedScroll
        if collectionViewPaginatedScroll == true {
            collectionView.isPagingEnabled = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func likeActionTriggered(_ sender: FaveButton) {
        updateLike()
    }
        
    func updateLike() {
        HUD.show(.progress)
        NBClient.shared.delay(1.0) {
            if !self.likeButton.isSelected {
                self.postForCell.likeFromCurrentUser!.deleteSelf()
            }
            else if self.likeButton.isEnabled {
                let newLike = Like(parent: self.postForCell)
                let finalLike = newLike.save()
                if finalLike == nil {
                    HUD.flash(.labeledError(title: "Server Error!", subtitle: "Well, this is embarrassing, something's wrong on our end."), delay: 0.5)
                    return
                }
            }
            HUD.flash(.success, delay: 0.5)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        self.showSwipe(orientation: .right, animated: true, completion: nil)
    }
    
    
    final func setCollectionView(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, indexPath: IndexPath) {
        collectionView.indexPath = indexPath
        
        if collectionView.dataSource == nil {
            collectionView.dataSource = dataSource
        }
        if collectionView.delegate == nil {
            collectionView.delegate = delegate
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postForCell.attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexedCollectionViewCell.identifier, for: indexPath) as! IndexedCollectionViewCell
        
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = String(format: "IndexedCollectionViewCell-%d-%d", indexPath.section, indexPath.item)
        cell.accessibilityLabel = cell.accessibilityIdentifier
        cell.contentView.accessibilityIdentifier = String(format: "IndexedCollectionContentView-%d-%d", indexPath.section, indexPath.item)
        cell.contentView.accessibilityLabel = cell.contentView.accessibilityIdentifier
        
        cell.attachment.accessibilityIdentifier = "IndexedCollectionCellImageView"
        cell.attachmentOverlay.accessibilityIdentifier = "IndexedCollectionCellOverlay"
        cell.attachmentCount.accessibilityIdentifier = "IndexedCollectionCellLabel"
        
        let attachmentForCell = self.postForCell.attachments[indexPath.item]
        
        if attachmentForCell.type.contains("image") {
            cell.attachment.kf.setImage(with: attachmentForCell.getUrlForAvatar()!.absoluteURL, placeholder: nil, options: [.transition(ImageTransition.fade(0.3))], completionHandler: { (image, error, cacheType, URL) in
                self.setNeedsLayout()
            })
            if indexPath.item == 2 && indexPath.item < self.postForCell.attachments.count-1 {
                cell.cellDisplaysOverlay(count: "+\(self.postForCell.attachments.count-2)", forceUpdate: false)
            }
            else {
                cell.attachmentOverlay.showViewAnimated(false)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var newphotos = [LightboxImage]()
        for attachment in self.postForCell.attachments {
            let lightboxPhoto = LightboxImage(imageURL: attachment.getUrlForAvatar()!.absoluteURL)
            newphotos.append(lightboxPhoto)
        }

        let lightbox = LightboxController(images: newphotos, startIndex: indexPath.item)
        lightbox.pageDelegate = self
        lightbox.dismissalDelegate = self
        lightbox.imageTouchDelegate = self
        lightbox.dynamicBackground = true
        
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
            return
        }
        if let homeVC = ((tabbarVC.viewControllers![0] as! UINavigationController).topViewController as? HomeFeedPostViewController) {
            homeVC.showingPhotoPicker = true
            homeVC.present(lightbox, animated: true, completion: nil)
            self.lightboxController = lightbox
        }
        else if let homeVC = ((tabbarVC.viewControllers![0] as! UINavigationController).topViewController as? HomeFeedViewController) {
            homeVC.present(lightbox, animated: true, completion: nil)
            self.lightboxController = lightbox
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item > 2 {
            return CGSize(width: 0, height: 90)
        }
        else {
            return CGSize(width: 90, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


extension HomeFeedPostCell: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate, LightboxControllerTouchDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        TTLog.debug("lightbox page: ", page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        TTLog.debug("lightbox dismiss")
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
            return
        }
        if let homeVC = ((tabbarVC.viewControllers![0] as! UINavigationController).topViewController as? HomeFeedPostViewController) {
            homeVC.showingPhotoPicker = false
        }
    }
    
    func lightboxController(_ controller: LightboxController, didTouch image: LightboxImage, at index: Int) {
        TTLog.debug("lightbox didtouch")
    }
}

extension HomeFeedPostCell {
    static var reuseId: String {
        return "postCell"
    }
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "HomeFeedPostCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    class func dequeue(from tableView: UITableView) -> HomeFeedPostCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? HomeFeedPostCell
    }
}
