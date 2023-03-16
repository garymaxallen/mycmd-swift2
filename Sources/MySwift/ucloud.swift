import CryptoKit
import Foundation

@available(macOS 10.15, *)
extension Digest {
  var bytes: [UInt8] { Array(makeIterator()) }
  var data: Data { Data(bytes) }

  var hexStr: String {
    bytes.map { String(format: "%02x", $0) }.joined()  // lower case
    // bytes.map { String(format: "%02X", $0) }.joined() // upper case
  }
}

func ucloud(_ limit: Int, _ offset: Int) {
  let PublicKey = "OmgolGAwCsGsMSo66+L0oDFKFUM6gVVKR0qsKTKwJr/zyCoKHsehIK8Ftq2DIotP"
  var params = [String: Any]()
  params = [
    "PublicKey": PublicKey,
    "Action": "DescribeVMInstance",
    "Region": "cn",
    "Zone": "zone-01",
    "Limit": limit,
    "Offset": offset,
  ]
  params = verify_ac(&params)
  NSLog("com.gg.mycmd.log: params: %@", String(describing: params))
  paramsRequest(params)

  // for (key, value) in params {
  //   NSLog("com.gg.mycmd.log: %@ : %@", key, String(describing: value))
  // }
  // NSLog("com.gg.mycmd.log: params: %@", String(describing: params))
}

func verify_ac(_ params: inout [String: Any]) -> [String: Any] {
  var params_data = ""
  let keys = params.keys.sorted()
  for key in keys {
    params_data = params_data + key + String(describing: (params[key]!))
  }
  let private_key = "e2a5a1cdf459e89d9ff7f52a8bd2e9c035a34ad7"
  params_data = params_data + private_key
  NSLog("com.gg.mycmd.log: params_data: %@", String(describing: params_data))

  let data = params_data.data(using: String.Encoding.utf8)!
  if #available(macOS 10.15, *) {
    let digest = Insecure.SHA1.hash(data: data)
    params["Signature"] = digest.hexStr
  } else {
    // Fallback on earlier versions
  }
  // NSLog("com.gg.mycmd.log: digest.data: %@", String(describing: digest.data))
  // NSLog("com.gg.mycmd.log: digest.hexStr: %@", digest.hexStr.lowercased())
  return params
}

func paramsRequest(_ params: [String: Any]) {
  var request = URLRequest(url: URL(string: "http://10.11.104.1/api")!)
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue("text/plain", forHTTPHeaderField: "Accept")
  request.httpMethod = "POST"
  request.httpBody = try? JSONSerialization.data(withJSONObject: params)
  NSLog("com.gg.mycmd.log: httpBody: %@", String(decoding: request.httpBody!, as: UTF8.self))
  URLSession.shared.dataTask(with: request) { data, response, error in
    NSLog("com.gg.mycmd.log: URLSession.shared.dataTask")
    guard let data = data, error == nil else {
      NSLog("com.gg.mycmd.log: responseJSON: %@", String(describing: error?.localizedDescription))
      return
    }
    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
    if let responseJSON = responseJSON as? [String: Any] {
      NSLog("com.gg.mycmd.log: responseJSON: %@", String(describing: responseJSON))
    }
  }.resume()
  DispatchSemaphore(value: 0).wait()
}
