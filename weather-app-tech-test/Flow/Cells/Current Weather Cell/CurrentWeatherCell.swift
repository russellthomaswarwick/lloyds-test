//
//  CurrentWeatherCell.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 18/12/2022.
//

import UIKit
import StackKit

final class CurrentWeatherCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.text = "Location"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let conditionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Mostly Sunny"
        label.numberOfLines = 2
        return label
    }()
    
    private let timeUpdatedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 60, weight: .heavy)
        return label
    }()
    
    private let lowTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: -

    private func setConstraints() {
        contentView.VStack {
            locationLabel
            conditionsLabel
            Spacer(h: 5)
            tempLabel
            VStack {
                HStack {
                    highTempLabel
                    Spacer(w: 10)
                    lowTempLabel
                }
            }.alignment(.center)
            .margin(.insets(top: 5, bottom: 10))
            timeUpdatedLabel
        }.margin(.all(20))
    }
    
    // MARK: - Bind
    
    var viewModel: CurrentWeatherViewModel? = nil {
        didSet {
            guard let viewModel = viewModel else { return }
            locationLabel.text = viewModel.locationText
            conditionsLabel.text = viewModel.conditionsText
            timeUpdatedLabel.text = viewModel.timeUpdatedText
            tempLabel.text = viewModel.tempText
            lowTempLabel.text = viewModel.lowTempText
            highTempLabel.text = viewModel.highTempText
        }
    }
}

