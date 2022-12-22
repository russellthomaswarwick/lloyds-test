//
//  ForecastCell.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 18/12/2022.
//

import UIKit
import StackKit

final class ForecastCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let conditionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    private let lowTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: -
    
    private func setConstraints() {
        contentView.VStack {
            HStack {
                dateLabel
                tempLabel
            }
            Spacer(h: 5)
            HStack {
                conditionsLabel
                VStack {
                    HStack {
                        highTempLabel
                        Spacer(w: 5)
                        lowTempLabel
                    }
                }.alignment(.trailing)
            }
        }.margin(.insets(top: 10, left: 10, bottom: 10, right: 20))
    }
    
    // MARK: - Bind
    
    var viewModel: ForecastViewModel? = nil {
        didSet {
            guard let viewModel = viewModel else { return }
            dateLabel.text = viewModel.dateText
            tempLabel.text = viewModel.tempText
            conditionsLabel.text = viewModel.conditionsText
            lowTempLabel.text = viewModel.lowTempText
            highTempLabel.text = viewModel.highTempText
        }
    }
}

