import { useState } from "react";

export default function CFinanceCalculator() {
  const [income, setIncome] = useState("");
  const [expenses, setExpenses] = useState("");
  const [result, setResult] = useState<number | null>(null);

  function calculate() {
    const savings = Number(income) - Number(expenses);
    setResult(savings);
  }

  return (
    <div style={{ padding: 24, maxWidth: 450 }}>
      <h2>C Finance Calculator</h2>

      <input
        type="number"
        placeholder="Monthly income"
        value={income}
        onChange={(e) => setIncome(e.target.value)}
      />

      <br /><br />

      <input
        type="number"
        placeholder="Monthly expenses"
        value={expenses}
        onChange={(e) => setExpenses(e.target.value)}
      />

      <br /><br />

      <button onClick={calculate}>Calculate Savings</button>

      {result !== null && (
        <div>
          <h3>Savings: ₹{result.toLocaleString("en-IN")}</h3>
          <p>{result >= 0 ? "Within budget" : "Over budget"}</p>
        </div>
      )}
    </div>
  );
}