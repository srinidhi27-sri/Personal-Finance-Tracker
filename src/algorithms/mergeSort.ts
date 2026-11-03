export type SortOrder='asc'|'desc';
/** Stable merge sort: O(n log n) time, O(n) auxiliary space. */
export function mergeSort<T>(items:T[], compare:(a:T,b:T)=>number):T[]{ if(items.length<=1)return [...items];const mid=Math.floor(items.length/2);const left=mergeSort(items.slice(0,mid),compare),right=mergeSort(items.slice(mid),compare);const out:T[]=[];let i=0,j=0;while(i<left.length&&j<right.length){if(compare(left[i],right[j])<=0)out.push(left[i++]);else out.push(right[j++]);}return out.concat(left.slice(i),right.slice(j)); }
