//
//  ContainerViewController.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 02/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit
import PanModal

class ContainerViewController: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    var itemCollection: ItemCollection!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        prepareCard(vc: vc)
        
        add(vc)
    }
    
    private func prepareCard(vc: ViewController) {
        vc.prices = buildPrices()
        vc.links = buildLinks()
        vc.brandNames = buildBrands()
        vc.marketLinks = buildMarketLinks()
        vc.titles = buildTitles()
        vc.brandNamesTruncated = buildTruncatedBrands()
    }
    
    private func buildTitles() -> [String] {
        var titles = [String]()
        
        itemCollection.items.forEach {
            if let title = $0?.name {
                titles.append(title)
            }
        }
        
        return titles
    }
    
    private func buildMarketLinks() -> [String] {
        var marketLinks = [String]()
        
        itemCollection.items.forEach {
            if let marketURLString = $0?.marketURLString {
                marketLinks.append(marketURLString)
            }
        }
        
        return marketLinks
    }
    
    private func buildBrands() -> [String] {
        var brands = [String]()
        
        itemCollection.items.forEach {
            if let brand = $0?.brand {
                brands.append(brand)
            }
        }
        
        return brands
    }
    
    private func buildTruncatedBrands() -> [String] {
        return buildBrands().map { $0.filter { $0.isLetter }.lowercased() }
    }
    
    private func buildLinks() -> [String] {
        var links = [String]()
        
        itemCollection.items.forEach {
            if let imageURLString = $0?.imageURLString {
                links.append(imageURLString)
            }
        }
        
        return links
    }
    
    private func buildPrices() -> [String] {
        var prices = [String]()
        
        itemCollection.items.forEach {
            if let price = $0?.price {
                prices.append(price + "₽")
            }
        }
        
        return prices
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(80)
    }
}
