# Array rotation by reversal method

def reverseArray(arr, start, end):
    while start < end:
        temp = arr[start]
        arr[start] = arr[end]
        arr[end] = temp
        start += 1
        end -= 1

def leftRotate(arr, d):
    if d == 0:
        return
    n = len(arr)
    d = d % n   # in case rotating factor is greater than array length
    reverseArray(arr, 0, d - 1)
    reverseArray(arr, d, n - 1)
    reverseArray(arr, 0, n - 1)

def printArray(arr):
    for i in range(0, len(arr)):
        print(arr[i])

arr = [1, 2, 3, 4, 5, 6, 7]
n = len(arr)
d = 2
  
leftRotate(arr, d)
printArray(arr)

# Search an element in sorted and rotated array
