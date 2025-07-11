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

//MARK: Remove Duplicates from Sorted Array
func removeDuplicates(_ nums: inout [Int]) -> Int {
    guard !nums.isEmpty else { return 0 }
    
    var index = 1
    for i in 1..<nums.count {
        if nums[i] != nums[index - 1] {
            nums[index] = nums[i]
            index += 1
        }
    }
    nums.removeLast(nums.count - index)
    print(nums)
    return nums.count
}
var duplicates = [1, 1, 2]
print("removeDuplicates: \(removeDuplicates(&duplicates))")


//MARK: Best time to buy and sell
func maxProfit(_ prices: [Int]) -> Int {
    
    guard !prices.isEmpty else {return 0}
    
    var start = 0
    var end = 0
    var maxProfit = 0
    
    while end <= prices.count - 1 {
        
        let startP = prices[start]
        let endP = prices[end]
        let profit = endP - startP
        
        if startP > endP {
            start += 1
        } else {
            maxProfit = max(maxProfit, profit)
            end += 1
        }
    }
    
    return maxProfit
}

//MARK: Max container height
func maxArea(_ height: [Int]) -> Int {
    
    guard !height.isEmpty else { return 0 }
    var start = 0
    var end = height.count - 1
    var maxArea = 0
    
    while start < end {
        let startH = height[start]
        let endH = height[start]
        
        let minH = min(startH, endH)
        let distanceX = end - start
        
        maxArea = max(maxArea, distanceX * minH)
        
        if startH < endH {
            start += 1
        } else {
            end -= 1
        }
    }
    return maxArea
}

//MARK: Linked list ops
final class LinkedNode {
    var val: Int
    var next: LinkedNode?
    
    init(_ val: Int) {
        self.val = val
    }
}


final class LinkedListOps {
    
    /*
     
     Reverse a linked list
     
     Input:
     1 -> 2 -> 3 -> 4 -> 5 -> NULL
     
     Output:
     NULL -> 5 -> 4 -> 3 -> 2 -> 1
     
     */
    
    static func reverse(_ node: LinkedNode?) -> LinkedNode? {
        
        guard let node else { return nil }
        
        var nextNode = node.next
        var currentNode = LinkedNode(node.val)
        
        while nextNode?.next != nil {
            let newNode = LinkedNode(nextNode!.val)
            newNode.next = currentNode
            currentNode = newNode
            
            nextNode = nextNode?.next
        }
        
        return currentNode
    }
    
    /*
     
     Add two linked list numbers, list is in reverse order
     
     2 -> 4 -> 3
     
     5 -> 6 -> 4
     
     */
    func addTwoNumbers(_ l1: LinkedNode?, _ l2: LinkedNode?) -> LinkedNode? {
        var dummyNode: LinkedNode? = LinkedNode(-1)
        var current = dummyNode
        var carry = 0
        
        var l1 = l1
        var l2 = l2
        
        while l1 != nil || l2 != nil || carry > 0 {
            
            var l1Val = l1?.val ?? 0
            var l2Val = l2?.val ?? 0
            let sum = l1Val + l2Val + carry
            
            carry = sum / 10
            current?.next = LinkedNode(sum%10)
            l1 = l1?.next
            l2 = l2?.next
            current = current?.next
        }
        return dummyNode?.next
    }
}

/* lengthOfLongestSubstring
 
 Input: s = "abcabcbb"
 Output: 3
 Explanation: The answer is "abc", with the length of 3
 
 */
func lengthOfLongestSubstring(_ s: String) -> Int {
    guard !s.isEmpty else { return 0 }
    var len = 0, chars = [Character]()
    for c in s {
        if let idx = chars.firstIndex(of: c) {
            chars.removeSubrange(0...idx)
        }
        chars.append(c)
        len = max(len, chars.count)
    }
    return len
}


/*
 
 merge two sorted arrays
 
 */

func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    
    if m == 0 {
        nums1 = nums2
    }
    
    guard n > 0 else {return}
    
    var p1 = m - 1
    var p2 = n - 1
    
    for p in stride(from: m + n - 1, to: 0, by: -1) {
        if p2 < 0 {
            break
        }
        
        if p1 >= 0 && nums1[p1] > nums2[p2] {
            nums1[p] = nums1[p1]
            p1 -= 1
        } else {
            nums1[p] = nums2[p2]
            p2 -= 1
        }
    }
}


/*
 
 String palindrome
 */

func isPalindrome(_ s: String) -> Bool {
    let s = Array(s.lowercased().filter { $0.isLetter || $0.isNumber })
    var left = 0
    var right = s.count - 1
    
    while left <= right {
        if s[left] != s[right] { return false }
        left += 1
        right -= 1
    }
    return true
}

let palindrome = "A man, a plan, a canal: Panama"
print("isPalindrome: \(isPalindrome(palindrome))")


/*
 
 move all zeroes
 */

func moveZeroes(_ nums: inout [Int]) {
    var index = 0
    for i in 0..<nums.count {
        if nums[i] != 0 {
            nums.swapAt(index, i)
            index += 1
        }
    }
}
