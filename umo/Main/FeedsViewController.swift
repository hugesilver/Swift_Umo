//
//  FeedsViewController.swift
//  umo
//
//  Created by 김태은 on 2023/05/30.
//

import UIKit
import Firebase

class FeedsViewController: UIViewController {
    @IBOutlet weak var feedsTableView: UITableView!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBAction func onTouchUpInsideUploadButton(_ sender: Any) {
        guard let uploadVC = self.storyboard?.instantiateViewController(identifier: "UploadFeedViewController") else {return}
        self.present(uploadVC, animated: true, completion: nil)
    }
    
    let profile = [UIColor(red: 1, green: 0, blue: 0, alpha: 1), UIColor(red: 0, green: 1, blue: 0, alpha: 1),UIColor(red: 0, green: 0, blue: 1, alpha: 1),]
    
    
    struct Feeds {
        let nickname: String
        let desc: String
        let image: String?
        
        init(nickname: String, desc: String, image: String?) {
            self.nickname = nickname
            self.desc = desc
            self.image = image
        }
    }
    
    var feeds: [Feeds] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        feedsTableView.dataSource = self
        feedsTableView.rowHeight = 625
        
        fetchFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchFeeds()
    }
    
    func fetchFeeds() {
        Firestore.firestore()
            .collection("feeds")
            .order(by: "sendTime", descending: true)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching feeds: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No feeds found")
                    return
                }
                
                // Clear previous data
                self.feeds.removeAll()
                
                for document in snapshot.documents {
                    if let data = document.data() as? [String: Any],
                       let nickname = data["nickname"] as? String,
                       let desc = data["desc"] as? String {
                       let image = data["image"] as? String
                       let feed = Feeds(nickname: nickname, desc: desc, image: image)
                       self.feeds.append(feed)
                    }
                }
                
                // Reload table view data
                self.feedsTableView.reloadData()
            }
    }


}
extension FeedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedsTableView.dequeueReusableCell(withIdentifier: "feedsCell", for: indexPath) as! FeedsTableViewCell
        
        let feed = feeds[indexPath.row] // Get the corresponding feed from the feeds array
        
        cell.profile.backgroundColor = profile[Int(arc4random_uniform(3))]
        cell.name.text = feed.nickname // Use the nickname field from the feed
        cell.feedText.text = feed.desc // Use the desc field from the feed
        
        if let imageURLString = feed.image, let imageURL = URL(string: imageURLString) {
            cell.setImageURL(imageURL)
        }
        
        return cell
    }
}

