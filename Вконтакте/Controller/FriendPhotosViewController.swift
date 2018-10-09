//
//  FriendPhotosViewController.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 20.07.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit
import RealmSwift

class FriendPhotosViewController: UICollectionViewController {
    
    let vkApiService = VKApiService()
    var photos = [Photo]()
    private let reuseIdentifier = "friendsPhotoCollectionCell"
    var ownerId: Int!
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        vkApiService.getUserPhotos(ownerId: ownerId) { (photos) in
            self.photos = photos
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.setTitle()
            }
            
        }
    }
    
    func setTitle() {
        if self.photos.count == 0 {
            self.navigationItem.title = "Загружаем..."
        } else {
            self.navigationItem.title = "Фото друга"
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FriendPhotosCollectionViewCell {
            
            let getCacheImage = GetCacheImage(url: photos[indexPath.item].url)
            let setImageToRow = SetImageToRow(indexPath: indexPath, collectionView: collectionView, cell: cell)
            setImageToRow.addDependency(getCacheImage)
            queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
extension FriendPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthForCell = view.frame.width / 4
        return CGSize(width: widthForCell, height: widthForCell)
    }
}
