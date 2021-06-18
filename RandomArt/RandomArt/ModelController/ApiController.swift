//
//  ApiController.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit
import CoreData

class ApiController {
    
    // MARK: - Properties
    
    let moc = CoreDataStack.shared.mainContext
    var usedIDs: [Int: String] = [-1: "Control"]
    
    private let baseURL = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1")!
    private lazy var departmentURL = baseURL.appendingPathComponent("/departments")
    private lazy var objectsURL = baseURL.appendingPathComponent("/objects")

    // MARK: - Public Functions
    
    /// called in HomeVC when the user taps the Enter button, so that data is available for display in DepartmentVC
    /// first checks if departments are already in CoreData and, if so, returns the saved department data
    /// when network request is necessary to fetch departments, they are saved in CoreData upon success
    /// - Parameter completion: upon success, returns an array - [Department]
    func fetchDepartments(completion: @escaping (Result<[Department], NetworkError>) -> Void) {
        let fetchRequest: NSFetchRequest<Department> = Department.fetchRequest()
        do {
            let departments = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            guard !departments.isEmpty else { throw CoreDataError.empty }
            completion(.success(departments))
        } catch {
            guard let request = getRequest(url: departmentURL, path: nil, queryKey: nil, queryValue: nil) else {
                completion(.failure(.failedRequestSetUp))
                return
            }
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.checkResponse(for: "fetchDepartments", data, response, error) { result in
                    switch result {
                    case .success(let data):
                        do {
                            let departmentReps = try JSONDecoder().decode(Departments.self, from: data)
                            var departments: [Department] = []
                            for depRep in departmentReps.departments {
                                let department = Department(departmentRep: depRep)
                                departments.append(department)
                            }
                            self.saveMOC()
                            completion(.success(departments))
                        } catch {
                            NSLog("Error decoding department data: \(error)")
                            completion(.failure(.failedDecoding))
                        }
                    default:
                        completion(.failure(.failedResponse))
                    }
                }
            }
            task.resume()
        }
    }
    
    /// called in DetailVC to fetch a random artwork from the user's selected department
    /// - Parameters:
    ///   - department: accepts a Department
    ///   - completion: upon success, returns an Artwork
    func fetchArt(department: Department, completion: @escaping (Result<Artwork, NetworkError>) -> Void) {
        fetchObjectIDs(department: department) { result in
            switch result {
            case .success(let IDs):
                self.fetchArtwork(objectIDs: IDs) { newResult in
                    switch newResult {
                    case .success(let artwork):
                        completion(.success(artwork))
                    default:
                        completion(.failure(.failedResponse))
                    }
                }
            default:
                completion(.failure(.failedResponse))
                return
            }
        }
    }
    
    /// called in fetchArt to fetch a list of objectIDs for the user's selected department
    /// first checks if objectIDs are already in CoreData for that department and, if so, returns the saved data
    /// when network request is necessary to fetch objectIDs, they are saved in CoreData upon success
    /// - Parameters:
    ///   - department: accepts a Department
    ///   - completion: upon success, returns an array - [Int64] for use in fetchArtwork
    func fetchObjectIDs(department: Department, completion: @escaping (Result<[Int64], NetworkError>) -> Void) {
        if let objectIDs = department.objectIDs, !objectIDs.isEmpty {
            completion(.success(objectIDs))
            return
        }
        guard let request = getRequest(url: objectsURL, path: nil, queryKey: "departmentIds", queryValue: String(Int(department.departmentId))) else {
            completion(.failure(.failedRequestSetUp))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.checkResponse(for: "fetchObjectIDs", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let objectIDs = try JSONDecoder().decode(ObjectIDs.self, from: data)
                        department.objectIDs = objectIDs.objectIDs
                        self.saveMOC()
                        completion(.success(objectIDs.objectIDs))
                    } catch {
                        NSLog("Error decoding objectIDs: \(error)")
                        completion(.failure(.failedDecoding))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    /// called in fetchArt to randomly select an objectID and fetch the artwork data for display in DetailVC
    /// checks to ensure that the same objectID has not already been used during the current user session
    /// continues to randomly chose new objectIDs until a new one is found, up to a maximum of 100 attempts
    /// saves the objectID in usedIDs along with the imageURL for use in the above check
    /// - Parameters:
    ///   - objectIDs: accepts an array of objectIDs, provided by fetchObjectIDs
    ///   - completion: upon success, returns an Artwork
    func fetchArtwork(objectIDs: [Int64], completion: @escaping (Result<Artwork, NetworkError>) -> Void) {
        var randomIndex = Int.random(in: 0..<objectIDs.count)
        var count = 0
        while usedIDs[Int(objectIDs[randomIndex])] != nil {
            if count > 100 {
                break
            }
            randomIndex = Int.random(in: 0..<objectIDs.count)
            count += 1
        }
        guard randomIndex != -1 else {
            completion(.failure(.otherError))
            return
        }
        let objectID = String(objectIDs[randomIndex])
        guard let request = getRequest(url: objectsURL, path: objectID, queryKey: nil, queryValue: nil) else {
            completion(.failure(.failedRequestSetUp))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.checkResponse(for: "fetchArtwork", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let artwork = try JSONDecoder().decode(Artwork.self, from: data)
                        self.usedIDs[artwork.objectID] = artwork.primaryImage
                        completion(.success(artwork))
                    } catch {
                        NSLog("Error decoding artwork: \(error)")
                        completion(.failure(.failedDecoding))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    /// called in DetailVC to fetch the image associated with an Artwork
    /// - Parameters:
    ///   - imageURL: accepts a url String
    ///   - completion: upon success, returns a UIImage
    func fetchImage(imageURL: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(.failure(.failedRequestSetUp))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.checkResponse(for: "fetchImage", data, response, error) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Private Functions
    
    /// Sets up a get request using a url and optional key and value for a query item
    /// - Parameters:
    ///   - url: accepts the url
    ///   - path: optional, accepts a String to add an appendingPathComponent
    ///   - queryKey: optional, accepts a String key for the query item - example: "departmentIds"
    ///   - queryValue: optional, accepts a String value for the query item - example: "1"
    /// - Returns: returns a get request after applying path component, query item and JSON extension
    private func getRequest(url: URL, path: String?, queryKey: String?, queryValue: String?) -> URLRequest? {
        var urlPath = url
        if let path = path {
            urlPath = url.appendingPathComponent(path)
        }
        if let key = queryKey,
           let value = queryValue {
            var component = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let queryItem = URLQueryItem(name: key, value: value)
            component?.queryItems = [queryItem]
            guard let newURL = component?.url else { return nil }
            urlPath = newURL
        }
        var request = URLRequest(url: urlPath)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    /// a helper function that checks data, response, and error from a data task
    /// - Parameters:
    ///   - taskDescription: accepts a String containing the function name where the data task is called for printing responses
    ///   - data: pass in the data received from the data task
    ///   - response: pass in the response received from the data task
    ///   - error: pass in the error received from the data task
    ///   - completion: returns either success(data) or failure(NetworkError)
    private func checkResponse(for taskDescription: String, _ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let error = error {
            NSLog("\(taskDescription) failed with error: \(error)")
            completion(.failure(.otherError))
            return
        }
        if let response = response as? HTTPURLResponse,
           !(200...210 ~= response.statusCode) {
            NSLog("\(taskDescription) failed response - \(response)")
            completion(.failure(.failedResponse))
            return
        }
        guard let data = data,
              !data.isEmpty else {
            NSLog("Data was not received from \(taskDescription)")
            completion(.failure(.noData))
            return
        }
        completion(.success(data))
    }
    
    /// a helper function for saving changes to CoreData objects
    /// - Returns: returns a Bool
    @discardableResult private func saveMOC() -> Bool {
        do {
            try moc.save()
            return true
        } catch {
            moc.reset()
            NSLog("Error saving managed object context: \(error)")
            return false
        }
    }
    
}
