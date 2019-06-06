//
//  CurrencyVCCell.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation
import UIKit

class CurrencyCell: BaseCell {
    
    var countryCurrencyNameLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Country, Currency"
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var lastUpdateCurrencyNameLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Last Update"
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    
    var buyTTLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "buyTT"
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var sellTTLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "sellTT"
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var buyTCLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "buyTC"
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var buyNotesLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "buy notes"
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var buyTTValueLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var sellTTValueLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var buyTCValueLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
    var buyNotesValueLbl: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize:15)
        return label
    }()
    
//    var bottomLablesStackView : UIStackView = {
//        let view = UIView()
//        //let stackView: UIStackView = UIStackView(arrangedSubviews: [buyTTLbl, sellTTLbl])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
    
    override func setupViews() {
        super.setupViews()
        
        let bottomLablesStackView : UIStackView = UIStackView(arrangedSubviews: [self.buyTTLbl, self.sellTTLbl, self.buyTTLbl,
                                                                                 self.buyTCLbl, self.buyNotesLbl])
        bottomLablesStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomLablesStackView.axis = .horizontal
        bottomLablesStackView.distribution = .fillEqually
        
        let bottomLablesValueStackView : UIStackView = UIStackView(arrangedSubviews: [self.buyTTValueLbl, self.sellTTValueLbl, self.buyTTValueLbl,
                                                                                 self.buyTCValueLbl, self.buyNotesValueLbl])
        bottomLablesValueStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomLablesValueStackView.axis = .horizontal
        bottomLablesValueStackView.distribution = .fillEqually
        
        
        // MARK: - Adding Views
        [self.countryCurrencyNameLbl, self.lastUpdateCurrencyNameLbl, bottomLablesStackView, bottomLablesValueStackView].forEach { addSubview($0) }
        
        // MARK: - Constraints
        countryCurrencyNameLbl.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: self.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 22))
        
        lastUpdateCurrencyNameLbl.anchor(top: self.countryCurrencyNameLbl.topAnchor, leading: nil, bottom: nil, trailing: self.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 16), size: .init(width: 0, height: 22))
        
        bottomLablesStackView.anchor(top: nil, leading: self.countryCurrencyNameLbl.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0), size: .init(width: 200, height: 22))

        bottomLablesValueStackView.anchor(top: nil, leading: self.countryCurrencyNameLbl.leadingAnchor, bottom: self.safeAreaLayoutGuide.bottomAnchor, trailing: self.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 200, height: 22))
    }
    
    func configure(countryName: String,
                   currencyName: String,
                   lasteUpdate: String,
                   buyTT: String,
                   sellTT: String,
                   buyTC: String,
                   buyNotes: String) {
        
        self.countryCurrencyNameLbl.text = "\(countryName), \(currencyName)"
        self.lastUpdateCurrencyNameLbl.text = lasteUpdate
        self.buyTTValueLbl.text = buyTT
        self.sellTTValueLbl.text = sellTT
        self.buyTCValueLbl.text = buyTC
        self.buyNotesValueLbl.text = buyNotes
        
    }
    
}
