//
// (c) Aron Budinszky (2022) - https://aron.budinszky.me
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension PostmarkSwift {
    
    /// Network communicator
    class ApiClient: ApiRequestCommunicating {
        
        // MARK: - Type definitions
        
        /// The possible errors
        enum Error: Swift.Error {
            case invalidBaseUrlGiven
            case unrecognizedError
        }
                
        /// Supported methods
        private enum Method: String {
            case GET, POST
        }
        
        // MARK: - Properties
        
        /// The base url of the client, with trailing slash
        let baseUrl: String
        
        /// The server token
        private let serverToken: String

        /// The URL Session object
        private let urlSession = URLSession(configuration: .default)
        
        /// The JSON encoder
        private let encoder = JSONEncoder()

        /// The JSON decoder
        private let decoder = JSONDecoder()

        // MARK: - Methods
        
        /// Initializer
        ///
        /// - Parameter baseUrl: The base url of the API, with trailing slash
        init(baseUrl: String = Constants.apiBaseUrl, serverToken: String) {
            self.baseUrl = baseUrl
            self.serverToken = serverToken
        }

        func get<RequestObject: RequestResponsePairing, ResponseObject: Decodable>(_ object: RequestObject, to endpoint: Constants.Endpoint) async throws -> ResponseObject {

            let data = try await self.request(object, to: endpoint, with: .GET)
            return try self.decoder.decode(ResponseObject.self, from: data)
        }

        func post<RequestObject: RequestResponsePairing, ResponseObject: Decodable>(_ object: RequestObject, to endpoint: Constants.Endpoint) async throws -> ResponseObject {

            let data = try await self.request(object, to: endpoint, with: .POST)
            return try self.decoder.decode(ResponseObject.self, from: data)
        }

        // MARK: - Private methods
        
        /// Send a request with a given endpoint
        ///
        /// - Parameter object: The request model object
        /// - Parameter endpoint: The endpoint to connect to
        /// - Parameter method: Which HTTP method to use
        /// - Returns: Returns the response data.
        private func request<RequestObject: RequestResponsePairing>(_ object: RequestObject, to endpoint: Constants.Endpoint, with method: Method) async throws -> Data {
            
            guard let url = URL(string: "\(self.baseUrl)\(endpoint.rawValue)") else {
                throw Error.invalidBaseUrlGiven
            }
            
            // Create and send request
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.httpBody = try? self.encoder.encode(object)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(self.serverToken, forHTTPHeaderField: "X-Postmark-Server-Token")
            let (data, response, error) = try await self.urlSession.asyncDataTask(with: request)
            
            // Make sure the response is valid
            guard error == nil else {
                throw error ?? Error.unrecognizedError
            }
            guard let _ = response as? HTTPURLResponse, let data = data else {
                throw Error.unrecognizedError
            }
            
            return data
        }
        
    }
}

