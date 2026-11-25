# LAB04

Вариант 4. Отзывы и опоздания  
$π_{o.order\_id,\ c.customer\_id,\ r.review\_score,\ d\ →\ delay}(
    (o ⋈_{o.customer\_id\ =\ c.customer\_id} c)
    ⋈_{o.order\_id\ =\ r.order\_id} r
)$

- `o` — `orders`, `c` — `customers`, `r` — `order_reviews`.
- `d` — длительность опоздания. Для доставленных заказов с обеими датами это разница между фактической и плановой датами доставки с нижней границей в ноль. В остальных случаях результат равен `NULL`.
