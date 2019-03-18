//
//  ViewController.swift
//  ChartsTGCiOS
//
//  Created by iMac on 15.03.2019.
//  Copyright © 2019 Nipel Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    var charts: [Chart]
    var slider: Slider
    let canvas: Canvas
    let sliderview: Canvas
    let display: Canvas
    let collectionGraphs: CollectionGraphs
    let collectionCharts: CollectionCharts
    
    init() {
        
        
        let rect = UIScreen.main.bounds
        
        canvas = Canvas(frame: CGRect(origin: CGPoint.zero, size: rect.size))
        
        var currentheight: CGFloat = 0
        let offset: CGFloat = 20.0
        currentheight = offset
        let displayheight = rect.height / 2.2
        let displayrect = CGRect(x: 0, y: currentheight, width: rect.size.width, height: displayheight)
        currentheight += displayheight
        display = Canvas(frame: displayrect)
        canvas.addSubview(display)
        
        
        let sliderhight: CGFloat = 50
        currentheight += 1
        let sliderrect = CGRect(x: 0, y: currentheight, width: rect.size.width, height: sliderhight)
        sliderview = Canvas(frame: sliderrect)
        currentheight += sliderhight
        canvas.addSubview(sliderview)
        
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 48, height: 48)
        
        let chartshight: CGFloat = 50
        let chartsrect = CGRect(x: 0, y: currentheight, width: rect.size.width, height: chartshight)
        currentheight += chartshight
        
        collectionCharts = CollectionCharts(frame: chartsrect, collectionViewLayout: layout)
        collectionCharts.register(CollectionCell.self, forCellWithReuseIdentifier: "Cell")
        collectionCharts.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 60/255, alpha: 1.0)
        collectionCharts.alwaysBounceHorizontal = true
        canvas.addSubview(collectionCharts)

        
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 48, height: 24)
        
      
        let graphsheight: CGFloat = 25
        let graphsrect = CGRect(x: 0, y: currentheight, width: rect.size.width, height: graphsheight)
        currentheight += graphsheight
        
        collectionGraphs = CollectionGraphs(frame: graphsrect, collectionViewLayout: layout)
        collectionGraphs.register(CollectionCell.self, forCellWithReuseIdentifier: "Cell")
        collectionGraphs.backgroundColor = UIColor(red: 50/1.1/255, green: 50/1.1/255, blue: 60/1.1/255, alpha: 1.0)
        collectionGraphs.alwaysBounceHorizontal = true
        canvas.addSubview(collectionGraphs)

        
        display.backgroundColor = UIColor(red: 149/255/2, green: 98/255/2, blue: 57/255/2, alpha: 1.0)
        sliderview.backgroundColor = UIColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0)
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
        
        collectionGraphs.dataSource = self
        collectionCharts.dataSource = self
        collectionGraphs.delegate = self
        collectionCharts.delegate = self
        
        guard charts.isEmpty == false else { return }
        charts.selectOnly(at: 0)
        guard let selected = charts.firstSelected else { return }
        load(chart: selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(with url: URL) {
        do {
            var charts = try File().parse(url: url)
            self.charts = charts
            guard charts.isEmpty == false else { return }
            charts.selectOnly(at: 0)
            guard let selected = charts.firstSelected else { return }
            load(chart: selected)
        } catch let error {
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case is CollectionGraphs: return charts.firstSelected?.count ?? 0
        case is CollectionCharts: return charts.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        switch collectionView {
        case is CollectionCharts:
            let model = charts[indexPath.item]
            var collectionitem = model.collectionItem
            collectionitem.set(size: CGSize(width: 48, height: 48))
            cell.set(drawables: [collectionitem])
        case is CollectionGraphs:
            guard let chart = charts.firstSelected else { break }
            var collectionitem = chart.itemgraph(at: indexPath.item)
            collectionitem.set(size: CGSize(width: 48, height: 24))
            cell.set(drawables: [collectionitem])
        default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case is CollectionCharts: detectInCharts(at: indexPath.item)
        case is CollectionGraphs: detectInGraphs(at: indexPath.item)
        default: break
        }
    }
    
    func detectInCharts(at index: Int) {
        charts.selectAndResignOthers(at: index)
        guard let selected = charts.firstSelected else { return }
        load(chart: selected)
        collectionCharts.reloadData()
        collectionGraphs.reloadData()
    }
    
    func detectInGraphs(at index: Int) {
        let smallindex = index
        guard var chart = charts.firstSelected else { return }
        guard let bigindex = charts.firstIndex(of: chart) else { return }
        chart.select(at: smallindex)
        charts[bigindex] = chart
        load(chart: chart)
        collectionGraphs.reloadData()
    }
    
    func load(chart: Chart) {
        
        var workchart = chart
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

