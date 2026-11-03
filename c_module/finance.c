
#include <stdio.h>

int main() {
    float income, expenses, savings;

    printf("PERSONAL FINANCE TRACKER\n");

    printf("Enter monthly income: ");
    scanf("%f", &income);

    printf("Enter monthly expenses: ");
    scanf("%f", &expenses);

    savings = income - expenses;

    printf("\n--- FINANCIAL SUMMARY ---\n");
    printf("Income: %.2f\n", income);
    printf("Expenses: %.2f\n", expenses);
    printf("Savings: %.2f\n", savings);

    if (savings >= 0)
        printf("Status: Within budget\n");
    else
        printf("Status: Over budget\n");

    return 0;
}
