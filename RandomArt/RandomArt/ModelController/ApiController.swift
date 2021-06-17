//
//  ApiController.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import Foundation
import CoreData

class ApiController {
    
    // MARK: - Properties
    
    let moc = CoreDataStack.shared.mainContext
    
    private let baseURL = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1")!
    private lazy var departmentURL = baseURL.appendingPathComponent("/departments")
    
    // MARK: - Public Functions
    
    func fetchDepartments(completion: @escaping (Result<[Department], NetworkError>) -> Void) {
        let fetchRequest: NSFetchRequest<Department> = Department.fetchRequest()
        do {
            let departments = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            guard !departments.isEmpty else { throw CoreDataError.empty }
            completion(.success(departments))
        } catch {
            let request = getRequest(url: departmentURL, urlPathComponent: nil)
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
    
    // MARK: - Private Functions
    
    /// Sets up a get request using a url and urlPathComponent
    /// - Parameters:
    ///   - url: accepts the url
    ///   - urlPathComponent: accepts an optional String to apply a urlPathComponent
    /// - Returns: returns a get request after applying the path component and JSON extension
    private func getRequest(url: URL, urlPathComponent: String?) -> URLRequest {
        var urlPath = url
        if let path = urlPathComponent {
            urlPath = url.appendingPathComponent(path)
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
