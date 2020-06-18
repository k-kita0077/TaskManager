import Foundation
import Alamofire
import SwiftyJSON














let array = ["テスト", "テスト２", "テスト２", "テスト", "テスト３", "テスト４", "テスト"]

for (i,value) in array.enumerated() {
    print(i)
}

var set = Set<String>()
let result = array.filter { set.insert($0).inserted }
print(result)


let dateUnix: TimeInterval = 1592147128
let date = NSDate(timeIntervalSince1970: dateUnix)

// NSDate型を日時文字列に変換するためのNSDateFormatterを生成
let formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd"

// NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
let dateStr: String = formatter.string(from: date as Date)

print(dateStr)
var str = "Hello, playground"
