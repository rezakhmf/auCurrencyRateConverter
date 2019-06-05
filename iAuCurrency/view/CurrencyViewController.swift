//
//  ViewController.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 3/6/19.
//  
//

import UIKit

class CurrencyViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    // MARK: - Parameteres
    
    let cellID: String = "CurrencyCellId"
    
    var viewmodel: CurrencyViewModel?
    
    public var products: [Product] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Currencies"
        
        collectionView?.backgroundColor = .white
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView!.collectionViewLayout = layout
        
        self.viewmodel = CurrencyViewModel()
        
        self.viewmodel?.fetchCurrencies { products in
            self.products = products
        }
        
        self.collectionView?.register(CurrencyCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CurrencyCell
        
        let product = products[indexPath.row]
        
        cell.layer.cornerRadius = 21.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

        cell.configure(countryName: product.country ?? "",
                       currencyName: product.currencyName ?? "",
                       lasteUpdate: product.lastupdated ?? "",
                       buyTT: product.buyTT ?? "",
                       sellTT: product.sellTT ?? "",
                       buyTC: product.buyTC ?? "",
                       buyNotes: product.buyNotes ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 8, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let colorName = UIColor.randomColor else {
            cell.backgroundColor = UIColor(named: "blue_currency")
            return
        }
        
        cell.backgroundColor = colorName
    }


}

