//
//  BusinessTableViewCell.swift
//  TacoMadre
//
//  Created by Alan Guerrero on 7/31/18.
//  Copyright © 2018 Alan Guerrero. All rights reserved.
//

import UIKit

// MARK: - BusinessTableViewCell

class BusinessTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessRating: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    
    // MARK: - Properties
    
    var imageCache: NSCache<AnyObject, AnyObject>! 
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(business: Business) {
        selectionStyle = .none
        businessNameLabel.text = business.name
        businessRating.text = "Rating\n\(String(business.rating))"
        businessDistance.text = "Distance: " + String(((business.distance / 1609.344)*10).rounded() / 10) + " mi"
        
        if let url = URL(string: business.image_url) {
            let tempUrl = url
            displayURLImage(of: url) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        if tempUrl == url {
                            self.businessImageView.image = data
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func displayURLImage(of imageURL: URL, completion: @escaping (Result<UIImage>) -> Void){
        let tempUrl = imageURL
        
        if let imageFromCache = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            //cached
            completion(.success(imageFromCache))
            return
        }
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Error downloading profile picture: \(error)")
                completion(.failure(error))
            } else if (response as? HTTPURLResponse) != nil {
                if let imageData = data {
                    guard let image = UIImage(data: imageData) else { return }
                    let imageToCache = UIImage(data: data!)
                    self.imageCache.setObject(imageToCache!, forKey: imageURL as AnyObject)
                    //noncache
                    if tempUrl == imageURL {
                        completion(.success(image))
                    } else {
                        return
                    }
                } else {
                    print("Couldn't get image: Image is nil")
                    completion(.failure(RequestError.invalidURL))
                }
            } else {
                print("Couldn't get response code")
                completion(.failure(RequestError.invalidURL))
            }
        }
        dataTask.resume()
    }

}
