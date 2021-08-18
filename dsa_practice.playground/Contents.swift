import UIKit

let numbers = [11, 50, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

//MARK:- Linear search
func linearSearch<T: Equatable>(_ a: [T], _ key: T) -> Int? {
    for i in 0..<a.count {
        if a[i] == key {
            return i
        }
    }
    return nil
}

print("linear search: \(String(describing: linearSearch(numbers, 43)))")


//MARK:- Binary search (recursive)
func binaryRecursive<T: Comparable>(_ a: [T], _ key: T, _ range: Range<Int>) -> Int? {
    if range.lowerBound >= range.upperBound {
        return nil
    } else {
        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound)/2
        
        if a[midIndex] > key {
            return binaryRecursive(a, key, range.lowerBound ..< midIndex)
        } else if a[midIndex] < key {
            return binaryRecursive(a, key, midIndex + 1 ..< range.upperBound)
        } else {
            return midIndex
        }
    }
}

//MARK:- Binary search (iterative)
func binaryIterative<T: Comparable>(_ a: [T], _ key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound)/2
        if a[midIndex] == key {
            return midIndex
        } else if a[midIndex] < key {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    return nil
}


/*
   Array should be sorted first!
 
   Many implementations of binary search calculate
    midIndex = (lowerBound + upperBound) /2
   This contains subtle bug that only appears with large arrays, because lowerBound + upperBound may overflow the maximum number an integer can hold.
   Unlikely on 64-bit CPU, but it definitely can on 32-bit
 */


//MARK:- Count occurances
// Array should be sorted first

func countOccurrences<T: Comparable>(_ key: T, _ a: [T]) -> Int {
    
    var leftBoundary: Int {
        var low = 0
        var high = a.count
        while low < high {
            let midIndex = low + (high - low)/2
            if a[midIndex] < key {
                low = midIndex + 1
            } else {
                high = midIndex
            }
        }
        return low
    }
    
    var rightBoundary: Int {
        var low = 0
        var high = a.count
        while low < high {
            let midIndex = low + (high - low)/2
            if a[midIndex] > key {
                high = midIndex
            } else {
                low = midIndex + 1
            }
        }
        return low
    }
    
    return rightBoundary - leftBoundary
}

let a = [0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11]
print("count occurrences: \(countOccurrences(3, a))")

//MARK:- Select min/max

func minimum<T: Comparable>(_ a: [T]) -> T? {
    guard var minimum = a.first else {
        return nil
    }
    for e in a.dropFirst() {
        minimum = e < minimum ? e : minimum
    }
    return minimum
}

func maximum<T: Comparable>(_ a: [T]) -> T? {
    guard var maximum = a.first else {
        return nil
    }
    for e in a.dropFirst() {
        maximum = e > maximum ? e : maximum
    }
    return maximum
}

// to minimize number of comparisons we can compare items in pairs //O(n)
func minimumMaximum<T: Comparable>(_ a: [T]) -> (min: T, max: T)? {
    guard var min = a.first else {
        return nil
    }
    var max = min
    let start = a.count % 2
    for i in stride(from: start, to: a.count, by: 2) {
        let pair = (a[i], a[i+1])
        
        if pair.0 > pair.1 {
            if pair.0 > max {
                max = pair.0
            }
            if pair.1 < min {
                min = pair.1
            }
        } else {
            if pair.1 > max {
                max = pair.1
            }
            if pair.0 < min {
                min = pair.0
            }
        }
    }
    return (min, max)
}


//MARK:- k-th largest element

// naive solution: O(nlogn), addition O(n) space
func kthLargest(_ a: [Int], k: Int) -> Int? {
    let len = a.count
    if k > 0 && k <= len {
        let sorted = a.sorted()
        return sorted[len - k]
    } else {
        return nil
    }
}

// faster solution: combines ideas of binary search and quicksort, O(n)
//public func randomizedSelect<T: Comparable>(_ array: [T], _ k: Int) -> T {
//    var a = array
//
//    func randomPivot<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> T {
//        let pivotIndex = Int.random(in: low ..< high)
//        a.swapAt(pivotIndex, high)
//        return a[high]
//    }
//
//    func randomizedPartition<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int) -> Int {
//        let pivot = randomPivot(&a, low, high)
//        var i = low
//        for j in low ..< high {
//            if a[j] <= pivot {
//                a.swapAt(i, j)
//                i += 1
//            }
//        }
//        a.swapAt(i, high)
//        return i
//    }
//
//    func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
//        if low < high {
//            let p = randomizedPartition(&a, low, high)
//            if k == p {
//                return a[p]
//            } else if k < p {
//                return randomizedSelect(&a, low, p - 1, k)
//            } else {
//                return randomizedSelect(&a, low, p + 1, k)
//            }
//        } else {
//            return a[low]
//        }
//    }
//
//    precondition(a.count > 0)
//    return randomizedSelect(&a, 0, a.count - 1, k)
//}
//
//print("kth largest: \(randomizedSelect([7, 92, 23, 9, -1, 0, 11, 6], 4))")

//MARK:- Two sum problem
/*
 For example, if the array is [3, 5, 2, -4, 8, 11] and the sum is 7, your program should return [[11, -4], [2, 5]] because 11 + -4 = 7 and 2 + 5 = 7.
 */
func twoSumProblem(_ a: [Int], _ sum: Int) {
    
    var dict = [Int: Int]()
    var pairs = [[Int]]()
    
    for i in 0..<a.count {
        let diff = sum - a[i]
        if dict[diff] != nil {
            pairs.append([diff, a[i]])
        }
        dict[a[i]] = i
    }
    
    print("pairs: \(pairs)")
}

twoSumProblem([3, 5, 2, -4, 8, 11], 7)

//MARK:- Max subarray problem

var array = [3, 3, 9, 9, 5]

/*
 
 5 -2 7 -3
 
 5  3 10 7
 
 
 */

func findMaxSum(_ a: [Int]) {
    
    var overAllSum = 0
    var currentSum = 0
    
    for i in 0..<a.count {
        currentSum = max(currentSum + a[i], a[i])
        overAllSum = max(currentSum, overAllSum)
    }
    print(overAllSum, overAllSum % 7)
}

findMaxSum(array)

//MARK:- Shuffle array O(n)
func shuffle<T: Comparable>(_ a: inout [T]) {
    for i in stride(from: a.count - 1, through: 1, by: -1) {
        let random = Int.random(in: 0...i)
        if i != random {
            a.swapAt(i, random)
        }
    }
}
shuffle(&array)
print("shuffle: \(array)")

//MARK:- Minimum difference pair
let minDiffArray = [2, 4, 5, 9, 7]

func findMinimumDifference(_ a: [Int]) {
    var min = abs(a[0] - a[1])
    for i in 0..<a.count - 1 {
        if abs(a[i] - a[i + 1]) < min {
            min = abs(a[i] - a[i + 1])
        }
    }
    print("min: \(min)")
}
findMinimumDifference(minDiffArray)
