//
//  HomeFeedCommentCell.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 3/19/18.
//  Copyright © 2018 Notebowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import FaveButton
import Haptica
import ObjectMapper
import SwipeCellKit
import Lightbox

class CommentCollectionViewFlowLayout: UICollectionViewFlowLayout {
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
class CommentCollectionView: UICollectionView {
    var indexPath: IndexPath!
}

class HomeFeedCommentCell: SwipeTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var designableView: DesignableView!
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UITextView!
    @IBOutlet weak var commentLikes: UILabel!
    @IBOutlet weak var commentLikeButton: FaveButton!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var collectionView: CommentCollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionFlowLayout: CommentCollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeActionStackView: UIStackView!

    var lightboxPhotos = [LightboxImage]()
    var commentForCell: Comment!
    var collectionViewPaginatedScroll: Bool?
    
    weak var lightboxController: LightboxController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initSetup()
    }
    
    func initSetup() {
        collectionView.register(UINib(nibName: "IndexedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: IndexedCollectionViewCell.identifier)
        collectionViewPaginatedScroll = true
        collectionViewHeight.constant = 0.0
        
        commentContent.wrapToContent()
        moreButton.setImage(UIImage(named: "more-vector")!.filled(withColor: .lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        
        commentLikeButton.isHaptic = true
        commentLikeButton.hapticType = .impact(.light)
    }
    
    func configure(comment: Comment) {
        commentLikeButton.setSelected(selected: comment.likedByCurrentUser, animated: false)
        
        commentLikes.text = comment.commentLikes.isEmpty ? " " : "\(comment.commentLikes.count)"
        if comment.text == nil { commentContent.isHidden = true }
        else { commentContent.text = comment.text! }
        
        if comment.editedAt != nil { (postedDate.text = comment.createdAt.relativelyFormatted + " (edited)") }
        else { (postedDate.text = comment.createdAt.relativelyFormatted) }
        
        if comment.isAnonymous {
            userName.text = "Anonymous"
            userAvatar.image = UIImage(named: "anonymous")!
        }
        else if comment.creator!.resourceKey == NBClient.shared.getCurrentUser().resourceKey {
            userName.text = comment.creator!.fullName
            userAvatar.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ])
        }
        else {
            userName.text = comment.creator!.fullName
            userAvatar.kf.setImage(with: comment.creator!.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ]
            )
        }

        if lightboxPhotos.isEmpty {
            for attachment in comment.commentAttachments {
                let lightboxPhoto = LightboxImage(imageURL: attachment.getUrlForAvatar()!.absoluteURL)
                self.lightboxPhotos.append(lightboxPhoto)
            }
        }
        
        if (!comment.commentAttachments.isEmpty) && (comment.commentAttachments.first!.type != nil) {
            if (comment.commentAttachments.first!.type.contains("image")) {
                collectionViewHeight.constant = 100.0
            }
        }
        else {
            collectionViewHeight.constant = 0.0
        }
        
        self.commentForCell = comment
    }
    
    final override func layoutSubviews() {
        super.layoutSubviews()
        collectionFlowLayout.paginatedScroll = collectionViewPaginatedScroll
        if collectionViewPaginatedScroll == true {
            collectionView.isPagingEnabled = false
        }
    }
    
    @IBAction func commentLikeButtonTapped(_ sender: FaveButton) {
        TTLog.debug("isselected: ", sender.isSelected)
        if !sender.isSelected {
            UIView.transition(with: self.commentLikes,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.commentLikes.text = (self.commentForCell.commentLikes.count - 1 == 0 ? "" : "\((self.commentForCell.commentLikes.count - 1))")
            }) { (_) in
                DispatchQueue.global(qos: .default).async {
                    let tempLike = self.commentForCell.likeFromCurrentUser!
                    self.commentForCell.commentLikes.removeAll(self.commentForCell.likeFromCurrentUser!)
                    self.commentForCell.likeFromCurrentUser = nil
                    self.commentForCell.likedByCurrentUser = false
                    
                    
                    let delete = NBNetworking.shared.request(.delete, url: tempLike.url.absoluteString)
                    TTLog.warning("delete url request: ", delete.description)
                    
                }
            }
        }
        else if sender.isSelected {
            UIView.transition(with: self.commentLikes,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.commentLikes.text = "\((self.commentForCell.commentLikes.count + 1))"
            }) { (_) in
                DispatchQueue.global(qos: .default).async {
                    let fakeLike = Mapper<Like>().map(JSON: ["_parent":self.commentForCell.url.absoluteString, "_owner":NBClient.shared.getCurrentUser().url.absoluteString])
                    self.commentForCell.likeFromCurrentUser = fakeLike
                    self.commentForCell.likedByCurrentUser = true
                    self.commentForCell.commentLikes.append(fakeLike!)
                    let payload: Any? = ["_parent": "\(self.commentForCell.url.absoluteString)"]
                    let post = NBNetworking.shared.request(.post, url: Like.endpoint, json: payload)
                    TTLog.warning("post url request: ", post.description)
                }
            }
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
        return self.commentForCell.commentAttachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexedCollectionViewCell.identifier, for: indexPath) as! IndexedCollectionViewCell
        let attachmentForCell = self.commentForCell.commentAttachments[indexPath.row]
        
        if attachmentForCell.type.contains("image") {
            cell.attachment.kf.setImage(with: attachmentForCell.getUrlForAvatar()!.absoluteURL, placeholder: nil, options: [.transition(ImageTransition.fade(0.3))], completionHandler: { (image, error, cacheType, URL) in
                self.setNeedsLayout()
            })
            if indexPath.row == 2 && indexPath.row < self.commentForCell.commentAttachments.count-1 {
                cell.cellDisplaysOverlay(count: "+\(self.commentForCell.commentAttachments.count-2)", forceUpdate: false)
            }
            else {
                cell.attachmentOverlay.showViewAnimated(false)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var newphotos = [LightboxImage]()
        for attachment in self.commentForCell.commentAttachments {
            let lightboxPhoto = LightboxImage(imageURL: attachment.getUrlForAvatar()!.absoluteURL)
            newphotos.append(lightboxPhoto)
        }
        let lightbox = LightboxController(images: newphotos, startIndex: indexPath.row)
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
        if indexPath.row > 2 {
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

extension HomeFeedCommentCell: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate, LightboxControllerTouchDelegate {
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

extension HomeFeedCommentCell {
    
    static var reuseId: String {
        return "commentCell"
    }
    
    class func register(in tableView: UITableView) {
        tableView.register(UINib(nibName: "HomeFeedCommentCell", bundle: nil), forCellReuseIdentifier: self.reuseId)
    }
    
    class func dequeue(from tableView: UITableView) -> HomeFeedCommentCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseId)
        return cell as? HomeFeedCommentCell
    }
}
