//
//  RecordingInteractor.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import Foundation
import CoreData

fileprivate let ENTITY = "Recording"

class RecordingInteractor {

    private var context: NSManagedObjectContext!

    init(_ context: NSManagedObjectContext) {
        self.context = context
    }

    func findAll() -> [Recording]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY)
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)
        return result as? [Recording] ?? nil
    }

    func create(createdAt: Int64, keywords: String, audioPath: String, imagePath: String, text: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: ENTITY, in: self.context)
        let recording = NSManagedObject(entity: entity!, insertInto: context)

        recording.setValue(createdAt, forKey: "createdAt")
        recording.setValue(keywords, forKey: "keywords")
        recording.setValue(audioPath, forKey: "filePath")
        recording.setValue(imagePath, forKey: "imagePath")
        recording.setValue(text, forKey: "text")

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }

    static func generateFileURLs() -> (audio: URL, image: URL) {
        
        let uuid = UUID().uuidString
        let audioFilename = uuid + ".caf"
        let imageFilename = uuid + ".png"
        return (audio: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(audioFilename),
                image: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename))
    }
}
