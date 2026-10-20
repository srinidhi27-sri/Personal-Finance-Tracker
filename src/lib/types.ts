export type TxType = 'income' | 'expense';
export type Transaction = { id: string; user_id?: string; title: string; amount: number; type: TxType; category: string; date: string; notes?: string | null; created_at?: string };
export type Budget = { id: string; user_id?: string; category: string; amount: number; month: string };
export type Goal = { id: string; user_id?: string; name: string; target_amount: number; saved_amount: number; deadline: string; created_at?: string };
export type Bill = { id: string; user_id?: string; name: string; amount: number; due_date: string; category: string; is_paid: boolean; recurrence: 'none'|'weekly'|'monthly'|'yearly'; created_at?: string };
export type Profile = { id: string; full_name: string; currency: string; created_at?: string };
export type Category = { id: string; user_id?: string | null; name: string; type: TxType; color: string; icon: string };
