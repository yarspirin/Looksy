//
//  InspirationViewController.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 30/11/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit
import PinterestLayout
import BetterSegmentedControl

final class InspirationViewController: UICollectionViewController {

    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        populateImages()
    }
    
    @IBAction func navigateToCamera(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CameraViewController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        print("Hello")
    }
    
    private func configureCollectionView() {
        setupCollectionViewInsets()
        setupLayout()
        registerHeader()
    }
    
    private func setupCollectionViewInsets() {
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        collectionView.contentInset = UIEdgeInsets(
            top: 15,
            left: 5,
            bottom: 49,
            right: 5
        )
    }
    
    private func setupLayout() {
        let layout: PinterestLayout = {
            if let layout = collectionViewLayout as? PinterestLayout {
                return layout
            }
            
            let layout = PinterestLayout()
            collectionView?.collectionViewLayout = layout
            
            return layout
        }()
        
        layout.delegate = self
        layout.cellPadding = 7
        layout.numberOfColumns = 2
    }
    
    private func populateImages() {
        Array(1...11).forEach {
            guard let image = UIImage(named: "\($0)") else {
                return
            }
            
            images.append(image)
        }
        
        images.shuffle()
    }
    
    private func registerHeader() {
        collectionView.register(UINib(nibName: "InspirationHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InspirationHeaderView")
    }
    
    @objc public func controlValueChanged(_ control: BetterSegmentedControl) {
        if control.index == 0 {
             
        } else if control.index == 1 {
        }
    }
}

extension InspirationViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InspirationHeaderView", for: indexPath) as! InspirationHeaderView
        headerView.frame.size.height = 56
        headerView.segmentedControl.segments = LabelSegment.segments(withTitles: ["Inspiration", "My looks"], normalTextColor: UIColor.lightGray, selectedTextColor: UIColor.white)
        headerView.segmentedControl.addTarget(self, action: #selector(InspirationViewController.controlValueChanged(_:)), for: .valueChanged)
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: 414, height: 56)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InspirationCell.self),
                                                      for: indexPath) as! InspirationCell
        
        cell.layer.cornerRadius = 5.0
        cell.starContainerView.layer.cornerRadius = 5.0
        let image = images[indexPath.item]
        cell.imageView.image = image
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? InspirationCell,
            let image = cell.imageView.image else {
                return
        }
        
        navigateToSegmentation(image: image)
    }
}

extension InspirationViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        
        let image = images[indexPath.item]
        return image.height(forWidth: withWidth)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 0
    }
}

extension InspirationViewController {
    private func navigateToSegmentation(image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let segmentationVC = storyboard.instantiateViewController(withIdentifier: String(describing: SegmentationViewController.self)) as! SegmentationViewController
        segmentationVC.modalPresentationStyle = .fullScreen
        segmentationVC.lookImage = image
        self.present(segmentationVC, animated: true, completion: nil)
    }
}
