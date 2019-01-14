//
//  MainViewController.swift
//  OneSkyTest
//
//  Created by UHP Mac 1 on 14/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    // MARK: outlets
    @IBOutlet var titleString: UILabel!
    @IBOutlet var subtitleString: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelText()
        
        // fetch translations
        fetchAllTranslations { (res) in
            guard let responseDict = res else {
                return
            }
            
            // TODO Dino
            print (responseDict)
        }
    }
    
    // MARK: view
    func setLabelText() {
        titleString.text = "title.text".localized
        subtitleString.text = "subtitle.text".localized
    }
    
    // MARK: Alamofire
    func fetchAllTranslations(completion: @escaping (NSDictionary?) -> Void) {
        let timestamp = String(Int(NSDate().timeIntervalSince1970))
        let APIsecret = "dHGOMPT2PBUBNnxBIUCf3WZjpj3umBnp"
        let hash = HashHelper.md5("\(timestamp)\(APIsecret)")
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        guard let url = URL(string: "https://platform.api.onesky.io/1/projects/155221/translations?api_key=8U4LzOEffpGTD4kbPNgJz6SOgL9sdmIb&timestamp=\(timestamp)&dev_hash=\(String(describing: hash))&locale=HR&source_file_name=Localizable.strings&export_file_name=TestLocalizable.strings") else {
            completion(nil)
            return
        }
        
        Alamofire.download(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
                //result closure
                if let path = DefaultDownloadResponse.destinationURL {
                    completion(NSDictionary.init(contentsOf: path))
                } else {
                    completion(nil)
                }
            })
    }
}
