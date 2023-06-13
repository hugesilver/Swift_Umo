//
//  FeedsTableViewCell.swift
//  umo
//
//  Created by 김태은 on 2023/05/30.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedText: UILabel!
    
    func setImageURL(_ url: URL) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url) {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.feedImage.image = image
                    }
                }
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
