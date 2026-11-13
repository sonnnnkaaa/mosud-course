# LAB03
Task: `state ∈ {SP, RJ, MG} AND city IS NOT NULL`  
$π_{customer\_unique\_id,\ city,\ state}(
    σ_{state\ ∈\ \{SP,\ RJ,\ MG\}\ ∩\ city\ IS\ NOT\ NULL}(
        ρ_{city\ ←\ customer\_city, state\ ←\ customer\_state} (customers)
    )
)$

- Результаты выражения в сложной форме и разбитой на 2 выборки эквиваленты.
- Выражение содержит дубликаты по `customer_unique_id`: из 66233 уникальны 63936.
