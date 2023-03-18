import Crypto
// import CryptoKit
import Foundation
import FoundationNetworking

func listVM(_ limit: Int, _ offset: Int) {
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
  let result = paramsRequest(params)
  // print("result", paramsRequest(params))
  for i in 0...(result["Infos"] as! [Any]).count - 1 {
    print("VMID:   ", ((result["Infos"] as! [Any])[i] as! [String: Any])["VMID"]!)
    print("Name:   ", ((result["Infos"] as! [Any])[i] as! [String: Any])["Name"]!)
    print("State:  ", ((result["Infos"] as! [Any])[i] as! [String: Any])["State"]!)
    print("CPU:    ", ((result["Infos"] as! [Any])[i] as! [String: Any])["CPU"]!)
    print("Memory: ", ((result["Infos"] as! [Any])[i] as! [String: Any])["Memory"]!)
    print("OSName: ", ((result["Infos"] as! [Any])[i] as! [String: Any])["OSName"]!)
    print()
  }
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

  // sha1 params_data
  params["Signature"] = Insecure.SHA1.hash(data: params_data.data(using: String.Encoding.utf8)!).map
  { String(format: "%02x", $0) }.joined()

  return params
}

func paramsRequest(_ params: [String: Any]) -> [String: Any] {
  var request = URLRequest(url: URL(string: "http://10.11.104.1/api")!)
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue("text/plain", forHTTPHeaderField: "Accept")
  request.httpMethod = "POST"
  request.httpBody = try? JSONSerialization.data(withJSONObject: params)
  NSLog("com.gg.mycmd.log: httpBody: %@", String(decoding: request.httpBody!, as: UTF8.self))
  let semaphore = DispatchSemaphore(value: 0)
  var result: [String: Any]? = nil
  URLSession.shared.dataTask(with: request) { data, response, error in
    NSLog("com.gg.mycmd.log: URLSession.shared.dataTask")
    guard let data = data, error == nil else {
      NSLog("com.gg.mycmd.log: responseJSON: %@", String(describing: error?.localizedDescription))
      return
    }
    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
    if let responseJSON = responseJSON as? [String: Any] {
      result = responseJSON
      semaphore.signal()
    }
  }.resume()
  semaphore.wait()
  return result!
}
