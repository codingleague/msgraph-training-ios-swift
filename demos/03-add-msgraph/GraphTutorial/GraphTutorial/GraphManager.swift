//
//  GraphManager.swift
//  GraphTutorial
//
//  Created by Jason Johnston on 8/19/19.
//  Copyright © 2019 Jason Johnston. All rights reserved.
//

import Foundation
import MSGraphClientSDK
import MSGraphClientModels

class GraphManager {
    
    // Implement singleton pattern
    static let instance = GraphManager()
    
    private let client: MSHTTPClient?
    
    private init() {
        client = MSClientFactory.createHTTPClient(with: AuthenticationManager.instance.getGraphAuthProvider())
    }
    
    public func getMe(completion: @escaping(MSGraphUser?, Error?) -> Void) {
        // GET /me
        let meRequest = NSMutableURLRequest(url: URL(string: "\(MSGraphBaseURL)/me")!)
        let meDataTask = MSURLSessionDataTask(request: meRequest, client: self.client, completion: {
            (data: Data?, response: URLResponse?, graphError: Error?) in
            guard let meData = data, graphError == nil else {
                completion(nil, graphError)
                return
            }
            
            do {
                // Deserialize response as a user
                let user = try MSGraphUser(data: meData)
                completion(user, nil)
            } catch {
                completion(nil, error)
            }
        })
        
        // Execute the request
        meDataTask?.execute()
    }
}
