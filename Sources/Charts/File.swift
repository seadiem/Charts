import Foundation



public struct File {
    
    
    public struct WhatICouldDecode: Codable {
        let colors: [String: String]
        let names: [String: String]
        let types: [String: String]
    }
    
    public struct WhatIDecodeManually {
        
        var dict = [String: [Int]]()
        
        init(dict: [String: Any]) {
            if let content = dict["columns"] as? [[Any]] {
                
                var intermediate: [String: [Int]] = [:]
                
                for item in content {
                    guard item.isEmpty == false else { continue }
                    var work = item
                    let worklabel = work[0]
                    
                    var label: String?
                    if let cast = worklabel as? String {
                        label = cast
                    }
                    
                    
                    let numbers = work.dropFirst().compactMap { $0 as? Int }
                    
                    if let unwraplabel = label {
                        intermediate[unwraplabel] = numbers
                    }
                }
                
                self.dict = intermediate
                
            }
        }
    }
    
    public init() {}
    
    public func parse(url: URL) throws -> [Chart] {
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let automaticarray = try decoder.decode([WhatICouldDecode].self, from: data)
        
        
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        guard let array = json as? [[String: Any]] else { throw Fileerror.couldNotParse }
        
        var mannualy = [WhatIDecodeManually]()
        for item in array {
            let man = WhatIDecodeManually(dict: item)
            mannualy.append(man)
        }
        
        guard automaticarray.indices == mannualy.indices else { throw Fileerror.couldNotParse }
        let indicies = automaticarray.indices
        
        var charts = [Chart]()
        
        for index in indicies {
            charts.append(Chart(autamatic: automaticarray[index], manually: mannualy[index]))
        }
        
        return charts
        
    }
    
    
    public func findFile() throws -> URL {
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for url in fileURLs {
                let component = url.lastPathComponent
                if component == "chart_data.json" {
                    return url
                }
            }
            throw Fileerror.nofile
        } catch {
            throw Fileerror.nofile
        }
        
    }
    
    public func findFileInRoot() -> URL {
        let string = "./Resource/chart_data.json"
        let url = URL(fileURLWithPath: string)
        return url
    }
    
    #if os(iOS)
    public func findFileInBundle() -> URL {
        let string = Bundle.main.bundlePath + "/Resource/chart_data.json"
        let url = URL(fileURLWithPath: string)
        return url
    }
    #endif
    
    func findFileDummyBitmap() throws -> URL {
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for url in fileURLs {
                let component = url.lastPathComponent
                if component == "orig.jpeg" {
                    return url
                }
            }
            throw Fileerror.nofile
        } catch {
            throw Fileerror.nofile
        }
        
    }
    
}

extension File {
    enum Fileerror: Error {
        case nofile
        case couldNotParse
    }
}
