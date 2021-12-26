import Foundation

class ChattingImpl {
    static let shared = ChattingImpl()
    private init() {}
    private let baseUrl = "http://127.0.0.1:8000"
    
    func execute<T: Codable>(_ text: String, completion: @escaping (Result<T, Error>) -> ()) {
        var urlString = text
        
        if !urlString.hasPrefix("http") {
            urlString = baseUrl + "/get_info/?date=" + text
        }
        
        let request = URLRequest(url: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ChattingError.invalidResponse))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(ChattingError.invalidStatusCode))
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

enum ChattingError: Error {
    case invalidResponse
    case invalidStatusCode
    case invalidData
}
