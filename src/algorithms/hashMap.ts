import type { Transaction } from '../lib/types';
/** O(n) build, expected O(1) lookup; worst-case depends on hash collisions. */
export function transactionIndex(items: Transaction[]): Map<string,Transaction> { const index=new Map<string,Transaction>(); for(const item of items) index.set(item.id,item); return index; }
export function findTransaction(index: Map<string,Transaction>, id: string) { return index.get(id) ?? null; }
