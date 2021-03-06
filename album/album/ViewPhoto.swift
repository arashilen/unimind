//
//  ViewPhoto.swift
//  album
//
//  Created by len on 2016/12/15.
//  Copyright © 2016年 unimind. All rights reserved.
//

import UIKit
import Photos

class ViewPhoto: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<PHAsset>!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true
        
        self.displayPhoto()
    }
    
    func displayPhoto()
    {
        if (self.index >= 0)
        {
            let imageManager = PHImageManager.default()
            _ = imageManager.requestImage(for: self.photosAsset[self.index], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil, resultHandler: {(result:UIImage?, info:[AnyHashable:Any]?)in
                self.imgView.image = result
            })
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        print("cancel clicked")
        
//        When you call popToRootViewController, the currently visible viewController disappears (after calling viewWillDisappear) and the first controller on the stack is shown.
//        All viewControllers in between are deallocated (after calling dealloc) without being shown. And if they are not shown, they can't disappear.
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnExport(_ sender: Any) {
        print("export clicked")
    }
    
    @IBAction func btnTrash(_ sender: Any) {
        print("trash clicked")
        
        let alert = UIAlertController(title: "刪除照片", message: "確定要刪除嗎？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: {(alertAction)in
            // Delete photo
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest(for: self.assetCollection)
 
                request?.removeAssets([self.photosAsset[self.index]] as NSFastEnumeration)
            }, completionHandler: { (success, error) in
                NSLog("\nDeleted Image -> \(success)")
                alert.dismiss(animated: true, completion: nil)
                
                self.photosAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                if (self.photosAsset.count == 0)
                {
                    self.imgView.image = nil
                    print("No image left!")
                }
                
                if (self.index >= self.photosAsset.count)
                {
                    self.index = self.photosAsset.count - 1
                }
                
                self.displayPhoto()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: {(alertAction)in
            // Keep photo
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
