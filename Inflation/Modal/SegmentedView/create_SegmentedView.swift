//
//  create()_SegmentedView.swift
//  Inflation
//
//  Created by Misha Dovhiy on 30.07.2023.
//

import UIKit

extension SegmentView {
    func create() {
       /* selectedIndicator.customTouchAnimation = { touched in
            selectedIndicator.layer.performAnimation(key: .)
        }*/
        preCreate()
        addTabs()
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .fill
        self.addSubview(stackView)
        stackView.addConstaits([.trailing:0, .leading:0,.top:0,.bottom:0], superV: self)
        createSelected()
        animateSelected(at: selectedIndex)
    }
    
    private func preCreate() {
        let background:UIView = .init()
        background.backgroundColor = mainBackgroundColor
        background.layer.cornerRadius = radious ?? size.height / 2
        self.insertSubview(background, at: 0)
        background.addConstaits([.leading:0,.trailing:0,.top:0,.bottom:0], superV: self)
        background.layer.zPosition = -1
    }
    
    private func createSelected() {
        guard let first = stackView.subviews.first else { return }
        let rad = (size.height + 4) / 2//radious ?? size.height / 2
        self.layer.cornerRadius = rad
        self.insertSubview(selectedIndicator, at: 0)
        let constraints = [
            selectedIndicator.widthAnchor.constraint(equalTo: first.widthAnchor, constant: -4),
            selectedIndicator.heightAnchor.constraint(equalTo: first.heightAnchor, constant: -4),
        ]
        selectedIndicator.addConstaits([.leading:2,.top:2,], superV: self)
        NSLayoutConstraint.activate(constraints)
        
        createShadow()
        selectedIndicator.layer.cornerRadius = rad - 4
        selectedIndicator.layer.shadow(opasity: 0.3, color: .black, radius: 6)
        
        createSelectedGradient()
        createSelectedGradientShadow()
    }
    
    private func createSelectedGradientShadow() {
        let toLayer = selectedShadowView ?? UIView()
        additionalGradientView = .init()
        additionalGradientView?.backgroundColor = UIColor.clear
       // additionalGradientLayer?.frame = .init(x: -10, y: -10, width: toLayer.frame.width + 20, height: toLayer.frame.height + 20)
        if let layer = self.additionalGradientView {
            toLayer.addSubview(layer)
        }
        
        setProportionalConstr(view: additionalGradientView ?? UIView(), toView: selectedShadowView, con: 0, superV: self)
        let superFrame:CGRect = .init(x: 0, y: 0, width: size.width / CGFloat(titles.count), height: size.height)
        let colors:[UIColor] = [
            UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 1),
            .blue,
            UIColor.init(red: 30/255, green: 237/255, blue: 137/255, alpha: 0.8),
            UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 1),//purp
            .blue,
        ]
        let frames:[CGRect] = [
            .init(x: 0, y: 0, width: superFrame.width / 3 + 50, height: superFrame.height),
            .init(x: superFrame.width / 3, y: 0, width: superFrame.width - (superFrame.width / 3), height: superFrame.height),
            .init(x: superFrame.width / 3 - 20, y: 20, width: superFrame.width / 2, height: superFrame.height - 20),
            .init(x: superFrame.width - (superFrame.width / 4), y: 0, width: superFrame.width / 4, height: superFrame.height),
            .init(x: superFrame.width - (superFrame.width / 6), y: 20, width: superFrame.width / 6, height: superFrame.height - 20),
        ]
        
        for i in 0..<frames.count {
            let new:CALayer = .init()
            new.frame = frames[i]
            new.cornerRadius = radious ?? self.size.height / 2
            new.backgroundColor = colors[i].cgColor
            new.shadow(opasity: 0.9, color: colors[i], radius: 8)
            additionalGradientView?.layer.addSublayer(new)
        }
        
    }
    
    
    
    private func createSelectedGradient() {
        let gradientLayer:CALayer = .init()
        let  frame:CGRect = .init(x: 0, y: 0, width: (size.width - 4) / CGFloat(titles.count), height: size.height - 4)
        gradientLayer.frame = frame
     //   gradientLayer.mulltippleGradient(.orangeBlue, dark: false, width: size.width / CGFloat(titles.count), height: size.height - 4)
        gradientLayer.cornerRadius = radious ?? (size.height - 4) / 2
        gradientLayer.masksToBounds = true
        selectedIndicator.layer.insertSublayer(gradientLayer, at: 1)
        selectedIndicatorGradient = gradientLayer
        let ovalWidth:CGFloat = frame.width / 1.75//frame.width / 1.75
        let ovalHeight = ovalWidth / 4
        let midPosition = frame.width / 2 + (ovalWidth / 2)
        let frames:[CGRect] = [
            .init(x: midPosition * (-1), y: 5, width: ovalWidth, height: ovalHeight),
            .init(x: (frame.width / 2) * (-1), y: 10, width: ovalWidth, height: ovalHeight),
            .init(x: 10, y: 20, width: ovalWidth, height: ovalHeight),
            .init(x: ((frame.width - 20) / 2) * (-1), y: (size.height + 20) / 2, width: ovalWidth, height: ovalHeight),
        ]
        let colors:[UIColor] = [
            UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 1),
            UIColor.init(red: 109/255, green: 31/255, blue: 238/255, alpha: 1),
            UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 1),
            UIColor.init(red: 30/255, green: 237/255, blue: 137/255, alpha: 0.5),
        ]
        
        createOvalGraditnts(toLayer: gradientLayer, colors: colors, frames: frames, supFrame: frame)
    }
    
    func createOvalGraditnts(toLayer:CALayer, colors:[UIColor], frames:[CGRect], supFrame:CGRect) {
        let ovalColors:[[CGColor]] = colors.compactMap { color in
            return [color.cgColor, color.withAlphaComponent(0).cgColor]
        }
        let ovalGradients:CALayer = .init()
        ovalGradients.frame = supFrame
        for i in 0..<frames.count {
            let new = ovalGradients.ovalGradient(frame: frames[i], color: ovalColors[i], insert: nil, middle: i == 3)
            new?.transform = CATransform3DMakeScale(4, 4, 1)
            //ovalGradients.masksToBounds = true
        }
        toLayer.addSublayer(ovalGradients)//.insertSublayer(ovalGradients, at: 1)
    }
    
    
    
    private func createShadow() {
        selectedShadowView = .init()
        self.insertSubview(selectedShadowView, at: 0)
        selectedShadowView.backgroundColor = .green
        setProportionalConstr(view: selectedShadowView, toView: selectedIndicator, con: 4, superV: self)
        selectedShadowView.layer.zPosition = -2
        selectedShadowView.layer.cornerRadius = radious ?? size.height / 2
    }
    
    
    func setProportionalConstr(view:UIView, toView:UIView, con:CGFloat, superV:UIView) {
        let constraints = [
            view.widthAnchor.constraint(equalTo: toView.widthAnchor, constant: con),
            view.heightAnchor.constraint(equalTo: toView.heightAnchor, constant: con),
        ]
        view.addConstaits([.leading:0,.top:0,], superV: superV)
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addTabs() {
        var i = 0
        titles.forEach { title in
            addTab(segment: title, id: i)
            i += 1
        }
    }
    
    private func addTab(segment:Segment, id:Int) {
        let newTag = stackView.arrangedSubviews.count
        let view = SegmentItem.init(title: segment.name,
                                    imgName: segment.iconName,
                                    id: id,
                                    selected: selectedSegment(_:))
        view.label.tag = titleLabels.count
        view.label.font = .systemFont(ofSize: view.label.font.pointSize, weight: fontWeight)
        titleLabels.append(view)
        view.tag = newTag
        stackView.addArrangedSubview(view)
    }
}
