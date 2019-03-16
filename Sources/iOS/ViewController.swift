//
//  ViewController.swift
//  ChartsTGCiOS
//
//  Created by iMac on 15.03.2019.
//  Copyright © 2019 Nipel Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var charts: [Chart]
    var slider: Slider
    let canvas: Canvas
    let sliderview: Canvas
    let display: Canvas
    
    init() {
        
        
        let rect = UIScreen.main.bounds
        
        canvas = Canvas(frame: CGRect(origin: CGPoint.zero, size: rect.size))
        
        let topoffset: CGFloat = 20.0
        let offset: CGFloat = 10.0
        let displayheight = rect.height / 2.2
        let displayrect = CGRect(x: 0, y: topoffset, width: rect.size.width, height: displayheight)
        display = Canvas(frame: displayrect)
        canvas.addSubview(display)
        
        let sliderhight: CGFloat = 50
        let sliderrect = CGRect(x: 0, y: 0 + topoffset + displayheight + offset, width: rect.size.width, height: sliderhight)
        sliderview = Canvas(frame: sliderrect)
        canvas.addSubview(sliderview)
        
        display.backgroundColor = UIColor(red: 149/255/2, green: 98/255/2, blue: 57/255/2, alpha: 1.0)
        sliderview.backgroundColor = UIColor(red: 149/255/1.9, green: 98/255/1.9, blue: 57/255/1.9, alpha: 1.0)
        canvas.backgroundColor = UIColor(red: 149/255/1.8, green: 98/255/1.8, blue: 57/255/1.8, alpha: 1.0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let first = "1985-06-11"
        let second = "1985-06-14"
        
        let one = formatter.date(from: first)!
        let two = formatter.date(from: second)!
        
        slider = Slider(width: Int(rect.size.width), height: Int(rect.size.height), begin: one, end: two)
        
        do {
            let url = File().findFileInBundle()
            let charts = try File().parse(url: url)
            self.charts = charts
        } catch let error {
            print(error)
            charts = []
        }
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(canvas)
        
        start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(with url: URL) {
        do {
            let charts = try File().parse(url: url)
            self.charts = charts
            start()
        } catch let error {
            print(error)
        }
    }
    
    func start() {
        guard charts.isEmpty == false else { return }
        
        var workchart = charts[4]
        workchart.set(screen: display.bounds.size)
        slider.set(bounds: workchart.bounds)
        
        var previewchart = workchart
        var resetslider = slider
        resetslider.reset()
        previewchart.set(screen: sliderview.bounds.size)
        previewchart.set(slider: resetslider.sliceSlider)
        previewchart.showDates = false
        
        let bitmap = Bitmap(drawable: previewchart, in: sliderview.bounds.size)
        
        sliderview.mousedown = { point in
            self.slider.touch(x: Int(point.x))
        }
        
        sliderview.mousedrug = { point in
            self.slider.input(x: Int(point.x))
            self.sliderview.setDrawables([bitmap, self.slider])
            workchart.set(slider: self.slider.sliceSlider)
            self.display.setDrawables([workchart])
        }
        
        sliderview.mouseup = { _ in
            self.slider.up()
        }
        
        self.sliderview.setDrawables([bitmap, self.slider])
        workchart.set(slider: self.slider.sliceSlider)
        self.display.setDrawables([workchart])
    }

}

