import Intents
import os.log

class IntentHandler: INExtension, DoorIntentHandling {
    let logger = OSLog(subsystem: "com.swift.auto", category: "IntentHandling")

    override func handler(for intent: INIntent) -> Any {
        if intent is DoorIntent {
            return self
        }
        return self
    }

    func handle(intent: DoorIntent, completion: @escaping (DoorIntentResponse) -> Void) {
        os_log("Handling intent", log: logger, type: .debug)

        // Prepare HTTP request
        guard let url = URL(string: "http://localhost/mqtt/sendMessage") else {
            os_log("Invalid URL", log: logger, type: .error)
            completion(DoorIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON Body
        let body: [String: Any] = [
            "topic": "test/topic",
            "message": "Test message"
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            os_log("JSON serialization failed: %@", log: logger, type: .error, String(describing: error))
            completion(DoorIntentResponse(code: .failure, userActivity: nil))
            return
        }

        // Send HTTP request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                os_log("HTTP request failed: %@", log: self.logger, type: .error, String(describing: error))
                completion(DoorIntentResponse(code: .failure, userActivity: nil))
                return
            }

            if httpResponse.statusCode == 200 {
                os_log("Message sent successfully via API", log: self.logger, type: .info)
                completion(DoorIntentResponse(code: .success, userActivity: nil))
            } else {
                os_log("HTTP response unsuccessful, Status Code: %d", log: self.logger, type: .error, httpResponse.statusCode)
                completion(DoorIntentResponse(code: .failure, userActivity: nil))
            }
        }
        task.resume()
    }
}

