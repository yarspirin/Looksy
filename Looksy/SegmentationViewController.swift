//
//  SegmentationViewController.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 30/11/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit
import PanModal
import RSLoadingView

final class SegmentationViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public var lookImage: UIImage!
    private var segmentedImage: UIImage?
    
    private var itemCollections = [ItemCollection]()
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var focusImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    @IBAction func show(_ sender: UIButton) {
        openCard()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let image = lookImage else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openCard() {
        guard let selectedIndexPath = itemsCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        let vc = ContainerViewController()
        vc.itemCollection = itemCollections[selectedIndexPath.item]
        presentPanModal(vc)
    }
    
    private func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1.0
        
        blurEffectView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor).isActive = true
    }
    
    private func setupAppearance() {
        focusImageView.layer.cornerRadius = 20.0
        backgroundImageView.layer.cornerRadius = 25.0
        updateImageViews(with: lookImage)
        blur()
    }
    
    func rotateImage(image: UIImage) -> UIImage? {
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
    
    private func submitRequest() {
        let loadingView = RSLoadingView()
        loadingView.shouldDimBackground = false
        loadingView.show(on: view)
        
        guard let imageData = rotateImage(image: lookImage)?.jpegData(compressionQuality: 0.3) else {
            return
        }
        
        let completion: ((SegmentationResult) -> Void) = { result in
            self.segmentedImage = result.segmentedImage
            self.itemCollections = result.itemCollections
            
            if let image = self.segmentedImage {
                self.updateImageViews(with: image)
            }
            
            self.itemsCollectionView.reloadData()
            loadingView.hide()
            self.itemsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .bottom)
        }
        
        Network.requestWith(url: "http://35.204.215.3:18000/process",
                            imageData: imageData,
                            parameters: [:],
                            onCompletion: completion
                            )
    }
    
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {

        let size = oldImage.size
        UIGraphicsBeginImageContext(size)

        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)

        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)

        bitmap.draw(oldImage.cgImage!, in: CGRect(origin: origin, size: size))

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func updateImageViews(with image: UIImage) {
        focusImageView.image = image
        backgroundImageView.image = image
    }
    
    private func registerNib() {
        let nib = UINib(nibName: ItemCell.nibName, bundle: nil)
        
        itemsCollectionView?.register(nib, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        
        if let flowLayout = self.itemsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        setupAppearance()
        
        DispatchQueue.main.async {
            self.submitRequest()
        }
    }
}

extension SegmentationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        
        cell.itemImageView.image = itemCollections[indexPath.item].image
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        cell.layer.cornerRadius = 5.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else {
            return
        }
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.openCard()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCell else {
            return
        }
        
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
}
