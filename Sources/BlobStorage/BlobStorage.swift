import Foundation

struct BlobStorage {
    private let configurationFileName = "index.json"
    private var _managed: [BlobContent] = []
    private var caches = LRU<Data, Date>(capacity: 20)

    var bundleName: String
    let workSpace: URL
    var configurationFile: URL {
        self.workSpace.appendingPathComponent(configurationFileName)
    }
    var managed: [BlobContent] {
        get { _managed }
        set {
            _managed = newValue
            updateConfig()
        }
    }

    init?(bundleName: String) throws {
        self.bundleName = bundleName
        guard let osCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        self.workSpace = URL(fileURLWithPath: osCachePath, isDirectory: true).appendingPathComponent(bundleName, isDirectory: true)
        try FileManager.default.createDirectory(at: workSpace, withIntermediateDirectories: true)
        try loadManagedContents()
    }

    private mutating func loadManagedContents() throws {
        let configurationURL = self.workSpace.appendingPathComponent(configurationFileName)
        guard FileManager.default.fileExists(atPath: configurationURL.path) else { return }
        let data = try Data(contentsOf: configurationURL)
        let decoder = JSONDecoder()
        _managed = try decoder.decode([BlobContent].self, from: data)
    }

    private mutating func updateConfig() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(_managed)
            try data.write(to: configurationFile)
        } catch {
            print(error.localizedDescription)
        }
    }

    mutating func save(item: BlobContent, data: Data) throws {
        let existedIndex = managed.firstIndex { (itemInList) -> Bool in
            itemInList.filename == item.filename
        }
        
        if existedIndex != nil {
            managed.remove(at: existedIndex!)
        }
        let targetURL = workSpace.appendingPathComponent(item.filename, isDirectory: false)
        try data.write(to: targetURL)
        managed.append(item)
        caches.put(key: item.createdAt, item: data)
    }

    mutating func remove(item: BlobContent) throws {
        guard let index = managed.lastIndex(of: item) else { return }
        managed.remove(at: index)
        caches.delete(key: item.createdAt)
        try FileManager.default.removeItem(at: workSpace.appendingPathComponent(item.filename))
    }

    mutating func fetch(item: BlobContent) -> Data? {
        let url = workSpace.appendingPathComponent(item.filename, isDirectory: false)
        let cached = caches.get(key: item.createdAt)
        
        if cached != nil {
            return cached
        } else if let data = try? Data(contentsOf: url) {
            caches.put(key: item.createdAt, item: data)
            return data
        }
        
        return nil
    }
    
    mutating func fetch(filename: String) -> Data? {
        fetch(item: .init(name: filename))
    }
}
