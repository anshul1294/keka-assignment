//
// TableViewCell.swift
// Cityflo
//
// Created by Anshul Gupta on 19/04/24.
// Copyright © Cityflo. All rights reserved.
//


import UIKit

class DataTableViewCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.textColor = UIColor.blue
        return label
    }()
    
    let titleImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let reuseIdentifier = String(describing: DataTableViewCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews(docData: Doc) {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(titleImage)
        
        titleLabel.text = docData.headline?.main
        descriptionLabel.text = docData.abstract
        dateLabel.text = DateConverter.convertDate(dateString: docData.actualPublicationDate ?? "")
        
        if let url = docData.multimedia?.first?.imageUrl {
            NetworkHelper.shared.downloadImage(from: url) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        self?.titleImage.image = image
                    }
                case .failure(let failure):
                    print("\(failure)")
                }
            }
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            titleImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleImage.widthAnchor.constraint(equalToConstant: 100),
            titleImage.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)

        ])
    }
}
