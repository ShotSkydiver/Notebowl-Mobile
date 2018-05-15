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
import NVActivityIndicatorView
import SwipeCellKit
import AXPhotoViewer

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

class HomeFeedCommentCell: SwipeTableViewCell, FaveButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AXPhotosViewControllerDelegate {
    
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentAttachments: ProfileImageView!
    @IBOutlet weak var commentLikes: UILabel!
    @IBOutlet weak var likeRefresh: NVActivityIndicatorView!
    @IBOutlet weak var commentLikeButton: FaveButton!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var collectionView: CommentCollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionFlowLayout: CommentCollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeActionStackView: UIStackView!
    
    var axPhotos = [AXPhoto]()
    var commentForCell: Comment!
    var commentLikeIndicator: NVActivityIndicatorView!
    var collectionViewPaginatedScroll: Bool?
    
    weak var photosViewController: AXPhotosViewController?
    
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
        
        commentLikeIndicator = NVActivityIndicatorView(frame: self.commentLikes.frame, type: .ballPulseSync, color: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        likeActionStackView.addSubview(commentLikeIndicator)
        
        commentLikeButton.isHaptic = true
        commentLikeButton.hapticType = .impact(.light)
    }
    
    func configure(comment: Comment) {
        commentLikeButton.setSelected(selected: comment.likedByCurrentUser, animated: false)
        
        if commentLikeIndicator.isAnimating {
            // likeRefresh.stopAnimating()
            commentLikeIndicator.stopAnimating()
            commentLikes.showViewAnimated(true)
        }
        
        commentLikes.text = comment.commentLikes.isEmpty ? "0" : "\(comment.commentLikes.count)"
        commentContent.text = comment.text
        postedDate.text = comment.createdAt.relativelyFormatted
        
        if comment.isAnonymous {
            userName.text = "Anonymous"
            userAvatar.image = UIImage(named: "anonymous")!
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
        
        if axPhotos.isEmpty {
            for attachment in comment.commentAttachments {
                let axphoto = AXPhoto(attributedTitle: nil, attributedDescription: nil, url: attachment.getUrlForAvatar()!.absoluteURL)
                self.axPhotos.append(axphoto)
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
        // setNeedsLayout()
        // layoutIfNeeded()
    }
    
    final override func layoutSubviews() {
        super.layoutSubviews()
        collectionFlowLayout.paginatedScroll = collectionViewPaginatedScroll
        if collectionViewPaginatedScroll == true {
            collectionView.isPagingEnabled = false
        }
        /*
         guard collectionView.frame != contentView.bounds else {
         return
         }
         collectionView.frame = contentView.bounds
         */
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        // likeRefresh.startAnimating()
        commentLikeIndicator.startAnimating()
        commentLikes.showViewAnimated(false)
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        self.showSwipe(orientation: .right, animated: true, completion: nil)
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        DispatchQueue.main.async {
            if (!self.commentLikeButton.isSelected) {
                getUrl(self.commentForCell.likeFromCurrentUser!.url.absoluteString, method: .delete)
            }
            else if (self.commentLikeButton.isSelected) {
                getUrl(Like.endpoint, method: .post, data: ["_parent": "\(self.commentForCell.url.absoluteString)"])
            }
        }
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
            if indexPath.row == 2 {
                // cell.attachmentCount.text = "+\(self.postForCell.postAttachments.count-2)"
                // cell.attachmentOverlay.alpha = 0.7
                cell.cellDisplaysOverlay(count: "+\(self.commentForCell.commentAttachments.count-2)", forceUpdate: false)
            }
            else {
                cell.attachmentOverlay.showViewAnimated(false)
                // cell.attachmentOverlay.alpha = 0.0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select image: ", indexPath)
        let currentCell = (collectionView as! CommentCollectionView).cellForItem(at: indexPath) as! IndexedCollectionViewCell
        
        let imageToDisplay = currentCell.attachment.image!
        let transitionInfo = AXTransitionInfo(interactiveDismissalEnabled: true, startingView: currentCell.attachment) { [weak self] (photo, index) -> UIImageView? in
            guard let `self` = self else {
                return nil
            }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = (collectionView as! CommentCollectionView).cellForItem(at: indexPath) as? IndexedCollectionViewCell else {
                return nil
            }
            return cell.attachment
        }
        let dataSource = AXPhotosDataSource(photos: self.axPhotos, initialPhotoIndex: indexPath.row)
        let pagingConfig = AXPagingConfig(interPhotoSpacing: 10.0)
        let photosViewController = AXPhotosViewController(dataSource: dataSource, pagingConfig: pagingConfig, transitionInfo: transitionInfo)
        photosViewController.delegate = self
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController!.presentedViewController as? MainTabBarViewController else {
            TTLog.debug("tabController is not presented!")
            return
        }
        guard let homeVC = ((tabbarVC.viewControllers![0] as! UINavigationController).topViewController as? HomeFeedPostViewController) else {
            TTLog.debug("homefeedpostVC is not presented!")
            return
        }
        homeVC.showingPhotoPicker = true
        homeVC.present(photosViewController, animated: true) {
            homeVC.showingPhotoPicker = false
        }
        self.photosViewController = photosViewController
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let cellHeight = self.bulletinTableView.rowHeight - (20)
        
        // this controls the size of the image in the collectionview
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
