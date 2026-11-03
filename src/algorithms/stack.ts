/** LIFO operation history; push/pop O(1). Store inverse actions for undo. */
export class UndoStack<T>{private items:T[]=[];push(item:T){this.items.push(item)}pop(){return this.items.pop()??null}peek(){return this.items.at(-1)??null}get size(){return this.items.length}clear(){this.items=[]}}
