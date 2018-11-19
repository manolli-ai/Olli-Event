//
//  CardCollectionViewCell.swift
//  Olli Vui
//
//  Created by MK on 5/10/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var viewPoint : UIView!
    @IBOutlet var image : UIImageView!
//    @IBOutlet var serrialNumber : UILabel!
    @IBOutlet var point : UILabel!
    var giffcard : GifCardMD = GifCardMD()
    let service : Services = Services()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUpUI() {
        self.point.text = self.giffcard.required
       self.image.frame.size.height = self.image.frame.size.width
        self.viewPoint.frame.origin.y = 5 //self.image.frame.size.height
        self.viewPoint.frame.origin.x = 5
        UIImage.downloadFromRemoteURL(giffcard.cover as URL, completion: { image, error in
            guard let image = image, error == nil else { print(error!);return }
            self.image.image = image
        })
    }

}

extension UIImage {
    static func downloadFromRemoteURL(_ url: URL, completion: @escaping (UIImage?,Error?)->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async{
                    completion(nil,error)
                }
                return
            }
            DispatchQueue.main.async() {
                completion(image,nil)
            }
            }.resume()
    }
}
