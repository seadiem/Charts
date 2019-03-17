import AppKit
import Charts

@available(OSX 10.11, *)
class WindowController: NSWindowController, NSWindowDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout, NSCollectionViewDelegate {

    var charts: [Chart]
    var slider: Slider
    let canvas: Canvas
    let sliderview: Canvas
    let display: Canvas
    let collectionGraphs: CollectionGraphs
    let collectionCharts: CollectionCharts
    
    
    init() {
        
        
        let rect = NSRect(x: 100, y: 100, width: 400, height: 435)
        let mask: NSWindow.StyleMask = [.resizable, .titled, .closable, .miniaturizable]
        let outwindow = NSWindow(contentRect: rect, styleMask: mask, backing: NSWindow.BackingStoreType.buffered, defer: false)
        outwindow.backgroundColor = NSColor.brown
        outwindow.makeKeyAndOrderFront(outwindow)
        outwindow.isOpaque = false
        outwindow.titleVisibility = .visible
        outwindow.title = "Charts"
    
        
        let mainMenu = NSMenu()
        let oneitem = NSMenuItem(title: "One", action: #selector(WindowController.pick), keyEquivalent: "O")
        let twoitem = NSMenuItem(title: "Two", action: #selector(WindowController.pick), keyEquivalent: "T")
        mainMenu.addItem(oneitem)
        mainMenu.addItem(twoitem)
        mainMenu.autoenablesItems = true
        mainMenu.showsStateColumn = true
        let fileMenu = NSMenu(title: "File")
        fileMenu.addItem(withTitle: "Open", action: #selector(WindowController.pick), keyEquivalent: "O")
        twoitem.submenu = fileMenu
        NSApp.mainMenu = mainMenu
        
        
        canvas = Canvas(frame: CGRect(origin: CGPoint.zero, size: rect.size))
        var currentheight: CGFloat = 10
        
        var layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 48, height: 24)
        
        
        let grapshight: CGFloat = 25
        let collectiongraphframe = CGRect(x: 0, y: currentheight, width: rect.width, height: grapshight)
        collectionGraphs = CollectionGraphs()
        collectionGraphs.collectionViewLayout = layout
        collectionGraphs.backgroundColors = [NSColor(red: 50/1.1/255, green: 50/1.1/255, blue: 60/1.1/255, alpha: 1.0)]
        collectionGraphs.register(CollectionItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionItem"))
        currentheight += grapshight
        var scrollView = NSScrollView(frame: collectiongraphframe)
        scrollView.documentView = collectionGraphs
        canvas.addSubview(scrollView)
        
        
        layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 48, height: 48)
        
        let chartshight: CGFloat = 50
        let collectionchartframe = CGRect(x: 0, y: currentheight, width: rect.width, height: chartshight)
        collectionCharts = CollectionCharts()
        collectionCharts.collectionViewLayout = layout
        collectionCharts.backgroundColors = [NSColor(red: 50/255, green: 50/255, blue: 60/255, alpha: 1.0)]
        collectionCharts.register(CollectionItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionItem"))
        currentheight += chartshight
        scrollView = NSScrollView(frame: collectionchartframe)
        scrollView.documentView = collectionCharts
        scrollView.autoresizesSubviews = true
        canvas.addSubview(scrollView)
        
        let detectchart = Detect(frame: collectionchartframe)
        canvas.addSubview(detectchart)
        
        let detectgraph = Detect(frame: collectiongraphframe)
        canvas.addSubview(detectgraph)
        
    
        
        let sliderhight: CGFloat = 50
        let sliderrect = CGRect(x: 0, y: currentheight, width: rect.size.width, height: sliderhight)
        sliderview = Canvas(frame: sliderrect)
        canvas.addSubview(sliderview)
        currentheight += sliderhight
        
        let displayheight: CGFloat = 289
        let offset: CGFloat = 1.0
        let displayrect = CGRect(x: 0, y: currentheight + offset, width: rect.size.width, height: displayheight)
        display = Canvas(frame: displayrect)
        canvas.addSubview(display)
        
        
        
        display.setBack(color:  CGColor(red: 149/255/2, green: 98/255/2, blue: 57/255/2, alpha: 1.0))
        sliderview.setBack(color:  CGColor(red: 149/255, green: 98/255, blue: 57/255, alpha: 1.0))
        canvas.setBack(color:  CGColor(red: 149/255/1.8, green: 98/255/1.8, blue: 57/255/1.8, alpha: 1.0))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let first = "1985-06-11"
        let second = "1985-06-14"
        
        let one = formatter.date(from: first)!
        let two = formatter.date(from: second)!
        
        slider = Slider(width: Int(rect.size.width), height: Int(rect.size.height), begin: one, end: two)
        
        
        do {
            let url = File().findFileInRoot()
            let charts = try File().parse(url: url)
            self.charts = charts

        } catch {

            print("no file in root")

            do {
                let url = try File().findFile()
                let charts = try File().parse(url: url)
                self.charts = charts
            } catch let error {
                print(error)
                charts = []
            }

        }
        
        super.init(window: outwindow)
        window?.contentView?.addSubview(canvas)
       
        detectchart.handler = detectInCharts
        detectgraph.handler = detectInGraphs
        
        collectionGraphs.dataSource = self
        collectionCharts.dataSource = self
        
        guard charts.isEmpty == false else { return }
        charts.selectOnly(at: 0)
        guard let selected = charts.firstSelected else { return }
        load(chart: selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(0)
    }

    
    @objc func pick() {
        let rect = CGRect(x: 100, y: 100, width: 500, height: 500)
        let panel = NSOpenPanel(contentRect: rect, styleMask: .closable, backing: .buffered, defer: false)
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.message = "Please, select 'chart_data.json'"
        panel.begin { result in
            guard let url = panel.url else { return }
            self.reload(with: url)
        }
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
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case is CollectionGraphs: return charts.firstSelected?.count ?? 0
        case is CollectionCharts: return charts.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionItem"), for: indexPath) as! CollectionItem

        switch collectionView {
        case is CollectionCharts:
            let model = charts[indexPath.item]
            var collectionitem = model.collectionItem
            collectionitem.set(size: CGSize(width: 48, height: 48))
            cell.set(drawables: [collectionitem])
        case is CollectionGraphs:
            guard let chart = charts.firstSelected else { break }
            var collectionitem = chart.itemgraph(at: indexPath.item)
            collectionitem.set(size: CGSize(width: 24, height: 48))
            cell.set(drawables: [collectionitem])
        default: break
        }
        
        return cell
        
    }
    
    func detectInCharts(at x: Int) {
        guard let index = detect(at: x, count: charts.count) else { return }
        charts.selectAndResignOthers(at: index)
        guard let selected = charts.firstSelected else { return }
        load(chart: selected)
        collectionCharts.reloadData()
        collectionGraphs.reloadData()
    }
    
    func detectInGraphs(at x: Int) {
        guard let selected = charts.firstSelected else { return }
        guard let smallindex = detect(at: x, count: selected.count) else { return }
        guard var chart = charts.firstSelected else { return }
        guard let bigindex = charts.firstIndex(of: chart) else { return }
        chart.select(at: smallindex)
        charts[bigindex] = chart
        load(chart: chart)
        collectionGraphs.reloadData()
    }
    
    func detect(at x: Int, count: Int) -> Int? {
        let itemwidth = 48
        var coords: [Int: Range<Int>] = [:]
        for item in 0..<count {
            let range = (itemwidth * item)..<(itemwidth * (item + 1))
            coords[item] = range
        }
        var index: Int?
        for (i, value) in coords {
            if value.contains(x) { index = i }
        }
        return index
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
