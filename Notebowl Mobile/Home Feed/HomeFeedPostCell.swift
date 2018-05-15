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
import NVActivityIndicatorView
import SwipeCellKit

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

class HomeFeedPostCell: SwipeTableViewCell, FaveButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var userAvatar: ProfileImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postComments: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    @IBOutlet weak var courseForPost: UILabel!
    @IBOutlet weak var collectionView: IndexedCollectionView!
    @IBOutlet weak var likeButton: FaveButton!
    @IBOutlet weak var commentButton: FaveButton!
    @IBOutlet weak var collectionFlowLayout: IndexedCollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var imageArray = [String] ()
    var likeIndicator: NVActivityIndicatorView!
    var postForCell: Post!
    var collectionViewPaginatedScroll: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        likeIndicator = NVActivityIndicatorView(frame: self.postLikes.frame, type: .ballPulseSync, color: #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1))
        addSubview(likeIndicator)
        
        likeButton.isHaptic = true
        likeButton.hapticType = .impact(.light)
        
        selectedBackgroundView?.backgroundColor = UIColor.cyan
    }
    
    func configure(post: Post) {
        likeButton.setSelected(selected: post.likedByCurrentUser, animated: false)
        
        if likeIndicator.isAnimating {
            likeIndicator.stopAnimating()
            postLikes.showViewAnimated(true)
        }
        
        postLikes.text = post.postLikes.isEmpty ? "0" : "\(post.postLikes.count)"
        postComments.text = post.postComments.isEmpty ? "0" : "\(post.postComments.count)"
        postContent.text = post.text
        courseForPost.text = post.owner!.courseFullName
        postedDate.text = post.createdAt.relativelyFormatted
        
        backgroundColor = post.pinned ? #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 0.1000000015) : UIColor(hexString: "#fdfdfd")
        
        if post.isAnonymous {
            userName.text = "Anonymous"
            userAvatar.image = UIImage(named: "anonymous")
        }
        else {
            userName.text = post.creator!.fullName
            userAvatar.kf.setImage(with: post.creator.profileUrl,
                                   options: [
                                    .transition(ImageTransition.fade(0.3)),
                                    .keepCurrentImageWhileLoading
                ]
            )
        }
        
        if (!post.postAttachments.isEmpty) && (post.postAttachments.first!.type != nil) {
            if (post.postAttachments.first!.type.contains("image")) {
                collectionViewHeight.constant = 100.0
                // self.setNeedsLayout()
            }
        }
        else {
            collectionViewHeight.constant = 0.0
        }

        self.postForCell = post
 
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeButtonAction(_ sender: Any) {
        
        likeIndicator.startAnimating()
        // likeRefresh.startAnimating()
        postLikes.showViewAnimated(false)
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        // DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        DispatchQueue.main.async {
            if (!self.likeButton.isSelected) {
                getUrl(self.postForCell.likeFromCurrentUser!.url.absoluteString, method: .delete)
            }
            else if (self.likeButton.isSelected) {
                getUrl(Like.endpoint, method: .post, data: ["_parent": "\(self.postForCell.url.absoluteString)"])
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
        return self.postForCell.postAttachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndexedCollectionViewCell.identifier, for: indexPath) as! IndexedCollectionViewCell
        let attachmentForCell = self.postForCell.postAttachments[indexPath.row]
        
        if attachmentForCell.type.contains("image") {
            
            // collectionViewHeight.constant = 100.0
            cell.attachment.kf.setImage(with: attachmentForCell.getUrlForAvatar()!.absoluteURL, placeholder: nil, options: [.transition(ImageTransition.fade(0.3))], completionHandler: { (image, error, cacheType, URL) in
                self.setNeedsLayout()
            })
            if indexPath.row == 2 {
                cell.attachmentOverlay.alpha = 0.7
            }
            else {
                cell.attachmentOverlay.alpha = 0.0
            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select image: ", indexPath)
        let currentCell = (collectionView as! IndexedCollectionView).cellForItem(at: indexPath) as! IndexedCollectionViewCell
        // show image detail
        // let imageToDisplay = currentCell.attachment.image!
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

