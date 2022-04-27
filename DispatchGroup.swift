import Foundation

struct  NoteCollection {
    var contents: [String]
    
    mutating func add(_ content: String) {
        self.contents.append(content)
    }
}

let group = DispatchGroup()

let collection = NoteCollection(contents: [String]())

group.enter()
loadDataSource.load { notes in 
    notes.forEach{ collection.add($0) }
    group.leave()
}

group.enter()
iCloudDataSource.load { notes in
    notes.forEach{ collection.add($0) }
    group.leave()
}

group.enter()
backendDataSource.load { notes in
    notes.forEach{ collection.add($0) }
    group.leave()
}

group.notify(queue: .main) { [weak self] in
    self?.render(collection)
}

extension Array where Element == DataSource {
    func load(completionHandler: @escaping (NoteCollection) -> Void) {
        let group = DispatchGroup()
        let collection = NoteCollecction(contents: [String]())
        
        for dataSource in self {
            group.enter() 
            dataSource.load { notes in
                collection.add(notes)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completionHandler(collection)
        }
    }
}
