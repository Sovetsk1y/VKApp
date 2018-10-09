//
//  SetImageToRow.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 29.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class SetImageToRow: Operation {
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?
    private var cell: FriendPhotosCollectionViewCell?
    
    init(indexPath: IndexPath, collectionView: UICollectionView, cell: FriendPhotosCollectionViewCell) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        self.cell = cell
    }
    
    override func main() {
        guard let collectionView = collectionView,
        let cell = cell,
        let getCacheImage = dependencies[0] as? GetCacheImage,
        let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = collectionView.indexPath(for: cell),
            newIndexPath == indexPath {
            cell.photoImageView.image = image
        } else if collectionView.indexPath(for: cell) == nil {
            cell.photoImageView.image = image
        }
    }
}
