import AppKit
import Charts

class WindowController: NSWindowController, NSWindowDelegate {
    
    var charts: [Chart]
    var slider: Slider
    let canvas: Canvas
    let sliderview: Canvas
    let display: Canvas

    
    init() {
        
        
        let rect = NSRect(x: 100, y: 100, width: 400, height: 300)
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
        
        let sliderhight: CGFloat = 50
        let sliderrect = CGRect(x: 0, y: 0, width: rect.size.width, height: sliderhight)
        sliderview = Canvas(frame: sliderrect)
        canvas.addSubview(sliderview)
        
        let offset: CGFloat = 10.0
        let displayrect = CGRect(x: 0, y: sliderhight + offset, width: rect.size.width, height: rect.size.height - sliderhight  - offset * 2)
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
        
        start()
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
