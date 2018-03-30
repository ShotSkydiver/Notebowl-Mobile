//
//  HomeFeedViewController.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 2/7/18.
//  Copyright © 2018 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import HGPlaceholders

class HomeFeedViewController: UITableVCWithNavbarImage, PlaceholderDelegate {
    var posts: [Post]!
    var loadingView: NBLoadingView!
    var bgView: UIView!
    
    @IBOutlet var bulletinTableView: HomeTableView!
    
    var placeholderTableView: TableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeFeedPostCell.register(in: bulletinTableView)

        self.tempLoadingViewSetup()
        placeholderTableView = bulletinTableView
        placeholderTableView?.placeholderDelegate = self
        
        self.getPosts()
    }

    func tempLoadingViewSetup() {
        self.loadingView = NBLoadingView()
        self.bgView = UIView(loadingView: self.loadingView)
        self.view.addSubview(bgView)
    }
    
    func view(_ view: Any, actionButtonTappedFor placeholder: HGPlaceholders.Placeholder) {
        placeholderTableView?.showDefault()
        
        self.getPosts()
    }
    
    func getPosts() {
        self.loadingView.showLoadView(true)
        self.bgView.showViewAnimated(true)
        
        DispatchQueue.main.async {
            self.posts = NBClient.shared.initArray(from: NBClient.shared.getMappable(Post.self, sortBy: "updatedAt:desc", limit: "6")!)
            self.bulletinTableView.reloadData()
                        
            self.bgView.showViewAnimated(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedRowIndexPath = self.bulletinTableView.indexPathForSelectedRow
        super.viewWillAppear(animated)
        
        if selectedRowIndexPath != nil {
            print("reloading")
            self.bulletinTableView.reloadData()
        }
        
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderCell = sender as? HomeFeedPostCell {
            let indexPath = self.bulletinTableView.indexPath(for: senderCell)!
            let destVC = segue.destination as! HomeFeedPostViewController
            destVC.currentIndex = indexPath
            destVC.post = self.posts[indexPath.row]
        }
    }
}


extension HomeFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.posts) != nil {
            return self.posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "postDetailSegue", sender: tableView.cellForRow(at: indexPath) as! HomeFeedPostCell)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellforrowat")
        let cell = HomeFeedPostCell.dequeue(from: tableView)!
        let post = self.posts[indexPath.row]

        cell.configure(post: post)
        return cell
    }
}

class NotebowlLogoNavigationItem: UINavigationItem {
    
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
    
    private let nbLogo = UIImage(named: "nb-logo-vector-white2")!
    private let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 22))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = nbLogo
        logoContainer.addSubview(logoImageView)
        self.titleView = logoContainer
        
    }
}

class HomeTableView: TableView {
    override func customSetup() {
        placeholdersProvider = .homeFeedPlaceholders
    }
}


public class ScaleAspectFitImageView : UIImageView {
    /// constraint to maintain same aspect ratio as the image
    private var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    public override init(image: UIImage!) {
        super.init(image:image)
        self.setup()
    }
    
    public override init(image: UIImage!, highlightedImage: UIImage?) {
        super.init(image:image,highlightedImage:highlightedImage)
        self.setup()
    }
    
    override public var image: UIImage? {
        didSet {
            self.updateAspectRatioConstraint()
        }
    }
    
    private func setup() {
        self.contentMode = .scaleAspectFit
        self.updateAspectRatioConstraint()
    }
    
    /// Removes any pre-existing aspect ratio constraint, and adds a new one based on the current image
    private func updateAspectRatioConstraint() {
        // remove any existing aspect ratio constraint
        if let c = self.aspectRatioConstraint {
            self.removeConstraint(c)
        }
        self.aspectRatioConstraint = nil
        
        if let imageSize = image?.size, imageSize.height != 0
        {
            let aspectRatio = imageSize.width / imageSize.height
            let c = NSLayoutConstraint(item: self, attribute: .width,
                                       relatedBy: .equal,
                                       toItem: self, attribute: .height,
                                       multiplier: aspectRatio, constant: 0)
            // a priority above fitting size level and below low
            c.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Double((UILayoutPriority.defaultLow.rawValue + UILayoutPriority.fittingSizeLevel).rawValue) / 2.0))
            self.addConstraint(c)
            self.aspectRatioConstraint = c
        }
    }
}
