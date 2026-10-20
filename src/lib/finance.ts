import type { Transaction, Budget, Goal, Bill } from './types';
export const sum = (xs: number[]) => xs.reduce((a,b)=>a+b,0);
export function totals(transactions: Transaction[]) {
  const income = sum(transactions.filter(t=>t.type==='income').map(t=>t.amount));
  const expenses = sum(transactions.filter(t=>t.type==='expense').map(t=>t.amount));
  return { income, expenses, balance: income-expenses, savingsRate: income>0 ? ((income-expenses)/income)*100 : 0 };
}
export function categoryTotals(transactions: Transaction[], type: 'income'|'expense'='expense') {
  const map = new Map<string,number>();
  transactions.filter(t=>t.type===type).forEach(t=>map.set(t.category,(map.get(t.category)||0)+t.amount));
  return [...map.entries()].map(([name,value])=>({name,value})).sort((a,b)=>b.value-a.value);
}
export function monthlyTotals(transactions: Transaction[]) {
  const map = new Map<string,{month:string;income:number;expenses:number}>();
  transactions.forEach(t=>{const month=t.date.slice(0,7);const row=map.get(month)||{month,income:0,expenses:0};row[t.type==='income'?'income':'expenses']+=t.amount;map.set(month,row)});
  return [...map.values()].sort((a,b)=>a.month.localeCompare(b.month));
}
export function budgetUsage(budgets: Budget[], transactions: Transaction[], month: string) {
 return budgets.filter(b=>b.month===month).map(b=>{const spent=sum(transactions.filter(t=>t.type==='expense'&&t.category===b.category&&t.date.startsWith(month)).map(t=>t.amount));return {...b,spent,percent:b.amount>0?spent/b.amount*100:0,remaining:b.amount-spent}});
}
export function goalProgress(goal: Goal) { return goal.target_amount>0 ? Math.min(100,Math.max(0,goal.saved_amount/goal.target_amount*100)):0; }
export function upcomingBills(bills: Bill[], today = new Date().toISOString().slice(0,10)) { return bills.filter(b=>!b.is_paid&&b.due_date>=today).sort((a,b)=>a.due_date.localeCompare(b.due_date)); }
export function friendlyInsights(transactions: Transaction[], budgets: Budget[], month = new Date().toISOString().slice(0,7)) {
 const out:string[]=[]; const current=transactions.filter(t=>t.date.startsWith(month)); const {income,expenses}=totals(current);
 if (!current.length) out.push('Add a transaction to start getting personal insights. Demo entries are labelled separately from your own records.');
 else { if(income>0) out.push(expenses<=income?`Nice work — you have ${Math.round((income-expenses)/income*100)}% of this month's recorded income left after expenses.`:'Your recorded expenses are higher than income this month. Review flexible spending before setting new goals.');
 const top=categoryTotals(current)[0]; if(top) out.push(`${top.name} is your largest spending category this month at ₹${top.value.toLocaleString('en-IN')}.`);
 const prev=transactions.filter(t=>t.type==='expense'&&t.date.slice(0,7)!==month); const prevMonth=[...new Set(prev.map(t=>t.date.slice(0,7)))].sort().at(-1); if(prevMonth){const p=sum(prev.filter(t=>t.date.startsWith(prevMonth)).map(t=>t.amount));if(p>0){const change=(expenses-p)/p*100;out.push(`Compared with ${prevMonth}, spending is ${Math.abs(Math.round(change))}% ${change>0?'higher':'lower'} this month.`)}}
 }
 budgets.filter(b=>b.month===month).forEach(b=>{const spent=sum(current.filter(t=>t.type==='expense'&&t.category===b.category).map(t=>t.amount));if(spent>b.amount)out.push(`Your ${b.category} budget is over by ₹${(spent-b.amount).toLocaleString('en-IN')}. Consider pausing non-essential purchases in this category.`);else if(spent>=b.amount*.8)out.push(`Heads-up: ${b.category} has used ${Math.round(spent/b.amount*100)}% of its budget.`)});
 return out;
}
