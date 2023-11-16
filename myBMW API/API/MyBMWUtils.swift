//
//  MyBMWUtils.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation
import CommonCrypto
import CryptoKit

public class MyBMWUtils {
    
    /// Generate correlation headers.
    public static func generateCorrelationHeaders() -> [String: String] {
        let id = UUID().uuidString
        return [
            "x-identity-provider": "gcdm",
            "x-correlation-id": id,
            "bmw-correlation-id": id,
        ]
    }
    
    /// Generate a random token with given length and characters.
    public static func generateToken(length: Int = 30) -> String {
        let characterSet: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        let characters = characterSet.map { String($0) }
        return (0..<length).map { _ in characters.randomElement() ?? "" }.joined()
    }
    
    /// Create `S256` code challenge with the given code verifier.
    public static func createS256CodeChallenge(from codeVerifier: String) -> String {
        guard let codeVerifierData = codeVerifier.data(using: .ascii) else {
            fatalError("Failed to convert the given code verifier to data.")
        }
        var codeChallenge = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        codeVerifierData.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(codeVerifierData.count), &codeChallenge)
        }
        let data = Data(codeChallenge)
        var base64String = data.base64EncodedString()
        // URL-safe base64 encoding
        base64String = base64String
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "="))
        return base64String
    }
    
    /// Generate a random `base64` string with size.
    public static func generateRandomBase64String(size: Int) -> String {
        var randomData = Data(count: size)
        randomData.withUnsafeMutableBytes { buffer in
            guard let baseAddress = buffer.baseAddress else { return }
            arc4random_buf(baseAddress, size)
        }
        return String(randomData.base64EncodedString().prefix(size))
    }
    
    /// Generate a `x-login-nonce` string.
    public static func generateCNNonce(username: String) throws -> String {
        let key = generateRandomBase64String(size: 16)
        let iv = generateRandomBase64String(size: 16)

        let k1 = String(key.prefix(8))
        let i1 = String(iv.prefix(8))
        let k2 = String(key.suffix(8))
        let i2 = String(iv.suffix(8))

        let username = username
        let bytesToDigest = Data((k2 + i1 + "u3.6.1" + username.suffix(4) + k1 + i2).utf8)
        let sha256Digest = SHA256.hash(data: bytesToDigest)
        let sha256Hex = sha256Digest.map { String(format: "%02hhx", $0) }.joined()
        
        let sha256A = String(sha256Hex.prefix(32))
        let sha256B = String(sha256Hex.suffix(32))

        let randomStr = k1

        let timeStr = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        let phoneText = "\(username)&\(timeStr)&\(randomStr)"

        let chars = Array("01234abcdefghijklmnopqrstuvwxyz56789")
        let k1r = chars[36 - chars.firstIndex(of: k1[k1.index(k1.startIndex, offsetBy: 4)])! - 1]
        let k2r = chars[36 - chars.firstIndex(of: k2[k2.index(k2.startIndex, offsetBy: 4)])! - 1]
        let aesKey = String(key.prefix(4)
                            + String(k1r)
                            + key.suffix(from: key.index(key.startIndex, offsetBy: 5)).prefix(7)
                            + String(k2r)
                            + key.suffix(from: key.index(key.startIndex, offsetBy: 13)))

        let bytesToSeal = Data(phoneText.utf8)
        let symetricKey = SymmetricKey(data: Data(aesKey.utf8))
        let cipherAES = try! AES.GCM.seal(bytesToSeal, using: symetricKey).combined!
        let aesHex = cipherAES.map({ String(format: "%02hhx", $0) }).joined()
        
        return k2 + i1 + sha256A + aesHex + k1 + i2 + sha256B
    }
}
