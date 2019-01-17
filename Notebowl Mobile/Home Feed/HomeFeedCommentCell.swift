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
import PKHUD
import ImageViewer

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
    @IBOutlet weak var dummyTextField: AutoSizeTextField!
    @IBOutlet weak var dummyStack: UIStackView!
    @IBOutlet weak var indentationConstraint: NSLayoutConstraint!
    @IBOutlet weak var indentationLine: UIView!
    @IBOutlet weak var indentationWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indentationTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var indentationBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userAvatarWidth: NSLayoutConstraint!
    @IBOutlet weak var userAvatarHeight: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentContent: UITextView!
    @IBOutlet weak var commentLikes: UILabel!
    @IBOutlet weak var commentReplies: UILabel!
    @IBOutlet weak var commentLikeButton: FaveButton!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var collectionView: CommentCollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var commentReplyButton: UIButton!
    @IBOutlet weak var collectionFlowLayout: CommentCollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeActionStackView: UIStackView!
    @IBOutlet weak var linkPreviewView: DesignableView!
    @IBOutlet weak var linkPreviewHeight: NSLayoutConstraint!
    @IBOutlet weak var linkPreviewTitle: UILabel!
    @IBOutlet weak var linkPreviewDescription: UILabel!
    @IBOutlet weak var linkPreviewUrl: UILabel!
    @IBOutlet weak var linkPreviewThumbnail: DesignableImageView!

    var commentForCell: Comment!
    var collectionViewPaginatedScroll: Bool?

    weak var galleryController: GalleryViewController!
    var items: [GalleryItem] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.accessibilityIdentifier = "IndexedCollectionView-DetailView"
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
        linkPreviewHeight.constant = 0.0

        userAvatarHeight.constant = 34.0
        userAvatarWidth.constant = 34.0
        indentationConstraint.constant = 0.0
        indentationWidthConstraint.constant = 1.5

        dummyTextField.borderStyle = .roundedRect
        dummyTextField.backgroundColor = UIColor(hexString: "#F6F6F8")
        dummyTextField.layer.borderColor = UIColor(hexString: "#CCD0D4").cgColor
        dummyTextField.layer.borderWidth = 1.5
        dummyTextField.layer.cornerRadius = 17.0
        dummyTextField.layer.masksToBounds = true

        commentContent.wrapToContent()

        commentLikeButton.isHaptic = true
        commentLikeButton.hapticType = .impact(.light)
    }

    func configure(comment: Comment) {
        commentLikeButton.addTarget(self, action: #selector(likeActionTriggered(_:)), for: UIControl.Event.touchUpInside)
        commentLikeButton.setSelected(selected: comment.likedByCurrentUser, animated: false)

        dummyTextField.isHidden = true

        indentationConstraint.constant = (comment.isCommentReply ? 40.0 : 0.0)
        userAvatarHeight.constant = (comment.isCommentReply ? 32.0 : 34.0)
        userAvatarWidth.constant = (comment.isCommentReply ? 32.0 : 34.0)
        indentationLine.backgroundColor = (comment.isCommentReply ? UIColor(hexString: "#DBDBDB") : UIColor.clear)
        if comment.isCommentReply {
            indentationTopConstraint.constant = (comment.parent! as! Comment).comments.first! == comment ? 0 : -8
            indentationBottomConstraint.constant = (comment.parent! as! Comment).comments.last! == comment ? 0 : 8
        }

        if !comment.commentLikes.isEmpty {
            commentLikes.text = comment.commentLikes.count == 1 ? "\(comment.commentLikes.count) Like" : "\(comment.commentLikes.count) Likes"
        } else {
            commentLikes.text = "Like"
        }

        if !comment.comments.isEmpty && comment.comments != nil {
            commentReplies.text = comment.comments.count == 1 ? "\(comment.comments.count) Reply" : "\(comment.comments.count) Replies"
        } else {
            commentReplies.text = " "
        }

        if comment.text == nil {
            commentContent.isHidden = true
        } else { commentContent.text = comment.text! }

        if comment.editedAt != nil {
            (postedDate.text = "• " + comment.createdAt.relativeShortFormat + " (edited)")
        } else {
            (postedDate.text = "• " + comment.createdAt.relativeShortFormat)
        }

        if comment.isAnonymous {
            userName.text = "Anonymous"
            userAvatar.forCurrentUser = false
            userAvatar.image = UIImage(named: "anonymous")!
        } else if comment.creator == NBClient.shared.getCurrentUser() {
            userName.text = comment.creator!.fullName
            userAvatar.kf.setImage(with: NBClient.shared.getCurrentUser().profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ])
        } else {
            userName.text = comment.creator!.fullName
            userAvatar.forCurrentUser = false
            userAvatar.kf.setImage(with: comment.creator!.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ]
            )
        }

        if items.isEmpty {
            for attachment in comment.attachments {
                let thumbUrl = URL(string: attachment.thumbnailUrl)!

                let galleryItem = GalleryItem.image { imageCompletion in
                    KingfisherManager.shared.retrieveImage(with: thumbUrl, options: [.transition(ImageTransition.fade(0.3))]) { result in
                        if let image = result.value?.image {
                            imageCompletion(image)
                        }
                    }
                }
                self.items.append(galleryItem)
            }
        }

        if let linkPreview = comment.externalAttachments.first(where: {$0.attachmentScheme == .External }) {
            linkPreviewHeight.constant = 70.0
            linkPreviewTitle.isHidden = false
            linkPreviewThumbnail.isHidden = false
            linkPreviewDescription.isHidden = false
            linkPreviewTitle.text = linkPreview.title
            linkPreviewDescription.text = linkPreview.desc ?? ""
            let hostUrl = URL(string: linkPreview.location ?? "")?.host
            linkPreviewUrl.text = hostUrl ?? ""

            if let linkUrl = linkPreview.thumbnailUrl {
                linkPreviewThumbnail.kf.setImage(with: URL(string: linkUrl)!, placeholder: nil,
                                                 options: [
                                                    .transition(ImageTransition.fade(0.3))
                    ])
            } else {
                linkPreviewThumbnail.isHidden = true
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkPreviewTapped(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            linkPreviewView.addGestureRecognizer(tapGesture)
        } else {
            linkPreviewHeight.constant = 0.0
            linkPreviewTitle.isHidden = true
            linkPreviewThumbnail.isHidden = true
            linkPreviewDescription.isHidden = true
        }

        if let firstAtt = comment.attachments.first, firstAtt.mimeType == .image {
            collectionViewHeight.constant = 100.0
        } else {
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

    @objc func linkPreviewTapped(_ sender: Any) {
        if let url = URL(string: commentForCell.externalAttachments.first?.location ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    @objc func replyTapped(_ sender: Any) {
        if let parentVC = parentViewController as? HomeFeedPostViewController {
            parentVC.setReplyToComment(comment: self.commentForCell)
        }
    }

    func updateLike() {
        HUD.show(.progress)
        NBClient.shared.delay(1.0) {
            if !self.commentLikeButton.isSelected {
                self.commentForCell.likeFromCurrentUser!.deleteSelf()
            } else if self.commentLikeButton.isEnabled {
                let newLike = Like(parent: self.commentForCell).save()
                if newLike == nil {
                    HUD.flash(.labeledError(title: "Server Error!", subtitle: "Well, this is embarrassing, something's wrong on our end."), delay: 0.5)
                    return
                }
            }
            HUD.flash(.success, delay: 0.5)
        }
    }

    @objc func likeActionTriggered(_ sender: FaveButton) {
        updateLike()
    }

    @IBAction func moreButtonAction(_ sender: Any) {
        self.showSwipe(orientation: .right, animated: true, completion: nil)
    }

    @IBAction func replyButtonPressed(_ sender: UIButton) {
        if let parentVC = parentViewController as? HomeFeedPostViewController {
            parentVC.setReplyToComment(comment: self.commentForCell)
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
        return self.commentForCell.attachments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexedCollectionViewCell.identifier, for: indexPath) as! IndexedCollectionViewCell
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = String(format: "IndexedCollectionViewCell-DetailView-%d-%d", indexPath.section, indexPath.item)
        cell.accessibilityLabel = cell.accessibilityIdentifier
        cell.contentView.accessibilityIdentifier = String(format: "IndexedCollectionContentView-DetailView-%d-%d", indexPath.section, indexPath.item)
        cell.contentView.accessibilityLabel = cell.contentView.accessibilityIdentifier
        cell.attachment.accessibilityIdentifier = "IndexedCollectionCellImageView-DetailView"
        cell.attachmentOverlay.accessibilityIdentifier = "IndexedCollectionCellOverlay-DetailView"
        cell.attachmentCount.accessibilityIdentifier = "IndexedCollectionCellLabel-DetailView"

        let attachmentForCell = self.commentForCell.attachments[indexPath.item]

        if attachmentForCell.mimeType == .image {
            cell.attachment.kf.setImage(with: URL(string: attachmentForCell.thumbnailUrl)!, placeholder: nil, options: [.transition(ImageTransition.fade(0.3))]) { result in }

            if indexPath.item == 2 && indexPath.item < self.commentForCell.attachments.count-1 {
                cell.cellDisplaysOverlay(count: "+\(self.commentForCell.attachments.count-2)", forceUpdate: false)
            } else {
                cell.attachmentOverlay.showViewAnimated(false)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shareButton = UIButton(type: .system)
        shareButton.frame.size = CGSize(width: 28, height: 28)
        shareButton.setBackgroundImage(UIImage(named: "upload-vector")!.filled(withColor: UIColor.groupTableViewBackground).withRenderingMode(.alwaysOriginal), for: .normal)

        let thumbButton = UIButton(type: .system)
        thumbButton.frame.size = CGSize(width: 28, height: 28)
        thumbButton.setBackgroundImage(UIImage(named: "gallery-vector")!.filled(withColor: UIColor.groupTableViewBackground).withRenderingMode(.alwaysOriginal), for: .normal)

        let galleryConfig: GalleryConfiguration = [
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(true),
            GalleryConfigurationItem.activityViewByLongPress(false),
            GalleryConfigurationItem.overlayColor(UIColor.darkGray),
            GalleryConfigurationItem.overlayColorOpacity(0.85),
            GalleryConfigurationItem.overlayBlurOpacity(0.85),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffect.Style.light),
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.custom(thumbButton)),
            GalleryConfigurationItem.thumbnailsLayout(.pinLeft(20, 28)),
            GalleryConfigurationItem.shareButtonMode(.custom(shareButton)),
            GalleryConfigurationItem.shareLayout(.pinRight(20, 72))
        ]

        let galleryVC = GalleryViewController(startIndex: indexPath.item, itemsDataSource: self, configuration: galleryConfig)

        if let parentVC = parentViewController as? HomeFeedPostViewController {
            self.galleryController = galleryVC
            parentVC.presentImageGallery(galleryVC)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item > 2 {
            return CGSize(width: 0, height: 90)
        } else {
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

extension HomeFeedCommentCell: GalleryItemsDataSource {
    func itemCount() -> Int {
        return items.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
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
