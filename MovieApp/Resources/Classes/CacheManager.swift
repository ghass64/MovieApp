//
//  CacheManager.swift
//  MovieApp
//
//  Created by Ghassan ALMarei on 7/12/17.
//  Copyright © 2017 Hawish Softwares. All rights reserved.
//

import UIKit

public enum CacheFile: String {
    case recentSearch = "RecentSearch"
}

class CacheManager: NSObject {

    //insert the array of any kind into cache with the name of the cache
    class func cacheList(list: [Any], type: CacheFile) -> Bool {
        //1- get the file name same as request url
        let cacheFileName = getCacheFileNameForList(type: type.rawValue)

        //2- get cache file path
        let cacheFilePath = String(format: "%@/%@", getDocumentsDirectoryPath(), cacheFileName)

        //3- create the dictionary to be serialized to JSON
        let dictToBeWritten: [String: Any] = [type.rawValue: list]

        //4- convert dictionary to NSData
        let dataToBeWritten = NSKeyedArchiver.archivedData(withRootObject: dictToBeWritten)

        //let result = dataToBeWritten.write(to: URL(fileURLWithPath: cacheFilePath), options: .atomicWrite)
        do {
            try dataToBeWritten.write(to: URL(fileURLWithPath: cacheFilePath), options: .atomicWrite)
            return true
        } catch {
            print(error)
            return false
        }
    }

    class func getCacheFileNameForList(type: String) -> String {
        //the file name is the string of listing URL without the page number and page size
        let fullURLString = "/" + type
        let correctURLstring = fullURLString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let str = correctURLstring?.components(separatedBy: "/\\?%*|\"<>:")
        return (str?.joined(separator: ""))!

    }

    class func getDocumentsDirectoryPath() -> String {
        let pathArray: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                   .userDomainMask, true) as [String]
        let documentsDirectoryPath: String = pathArray[0] as! String
        return documentsDirectoryPath

    }

    class func getCachedList(type: CacheFile, count: Int) -> [Any] {
        //1- get the file name same as request url
        let cacheFileName = getCacheFileNameForList(type: type.rawValue)

        //2- get cache file path
        let cacheFilePath = String(format: "%@/%@", getDocumentsDirectoryPath(), cacheFileName)

        var archiveData: Data
        do {
            archiveData = try NSData(contentsOf: URL(fileURLWithPath: cacheFilePath),
                                     options: NSData.ReadingOptions()) as Data
        } catch {
            print(error)
            return []
        }

        let dataDict: [String: Any] = NSKeyedUnarchiver.unarchiveObject(with: archiveData) as! [String: Any]

        let dataRaw = dataDict[type.rawValue]
        let resultArray = dataRaw as! [Any]

        //check if the returned array is more than the count , to show the exact count ,, else will return all
        //also check if the count is -1 , which means to return all array
        if count != -1 && resultArray.count > count {

            let arraySlice = resultArray.suffix(count)
            let CountedResultArray = Array(arraySlice)

            return CountedResultArray
        } else {
            return resultArray
        }
    }

    class func clearCachedList(type: CacheFile) {
        //1- get the file name same as request url
        let cacheFileName = getCacheFileNameForList(type: type.rawValue)

        //2- get cache file path
        let cacheFilePath = String(format: "%@/%@", getDocumentsDirectoryPath(), cacheFileName)

        //check if the file expiration date
        let fm = FileManager.default

        do {
            try fm.removeItem(atPath: cacheFilePath)

        } catch {
            print(error)
        }
    }

    class func cachedListCounter(type: CacheFile) -> Int {
        let cachedArr = getCachedList(type: type, count: -1)
        return cachedArr.count
    }

    class func clearAllCached() {
        clearCachedList(type: .recentSearch)
    }

    //Method to remove the duplicate items in the array of Strings
    class func uniqueElementsFrom(array: [String]) -> [String] {
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
}
