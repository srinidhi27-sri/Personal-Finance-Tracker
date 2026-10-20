/** Iterative binary search. Input must already be sorted ascending by the same key. O(log n) time, O(1) space. */
export function binarySearch<T>(items:T[], target:string|number, key:(item:T)=>string|number):number { let lo=0,hi=items.length-1;while(lo<=hi){const mid=Math.floor((lo+hi)/2),v=key(items[mid]);if(v===target)return mid;if(v<target)lo=mid+1;else hi=mid-1;}return -1; }
