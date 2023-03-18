// import Base32
import Crypto
import Foundation

func mytotp() {
  let secret = "AICRSHHFUHB2XGSHLO6QSNDMJYPIUKQC"
  let key = base32DecodeToData(secret)
  // print("secret data: ", key!.map { String(format: "%02x", $0) }.joined())

  let epoch = Int(Date().timeIntervalSince1970)
  print("epoch_2: ", epoch)
  var counter = Int(floor(Double(epoch) / 30))
  print("counter: ", counter)
  var counterData = withUnsafeBytes(of: &counter) { Array($0) }
  counterData.reverse()
  // let numbers: [UInt8] = [0, 0, 0, 0, 3, 86, 14, 166]
  // counterData = numbers
  print("counterData: ", counterData)

  let hash = HMAC<Insecure.SHA1>.authenticationCode(
    for: counterData, using: SymmetricKey(data: key!))
  var truncatedHash = hash.withUnsafeBytes { ptr -> UInt32 in
    let offset = ptr[hash.byteCount - 1] & 0x0f

    let truncatedHashPtr = ptr.baseAddress! + Int(offset)
    return truncatedHashPtr.bindMemory(to: UInt32.self, capacity: 1).pointee
  }
  truncatedHash = UInt32(bigEndian: truncatedHash)
  truncatedHash = truncatedHash & 0x7FFF_FFFF
  truncatedHash = truncatedHash % UInt32(pow(10, Float(6)))

  print("totp: ", String(format: "%0*u", 6, truncatedHash))
  // print("CryptoKitFixed OTP value: \(String(format: "%0*u", 6, truncatedHash))")

}
