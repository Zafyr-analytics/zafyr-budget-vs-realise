{#
  Ecart générique réel vs budget, robuste au NULL (usage LEFT JOIN).
  Formule : réel - budget.
  Convention : positif = réel supérieur au budget.
  Interprétation métier (favorable/défavorable) à la charge du mart appelant.
#}

{% macro ecart_budgetaire(reel, budget) %}
    COALESCE({{ reel }}, 0) - COALESCE({{ budget }}, 0)
{% endmacro %}





