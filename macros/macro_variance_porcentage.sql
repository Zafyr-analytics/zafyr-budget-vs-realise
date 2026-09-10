{#
    Nom : ecart_pct
    Objectif : calcule l'écart en % entre réel et budget, sign convention (réel - budget) / budget.
    Arguments :
        - actual_col : colonne ou expression SQL du réel
        - budget_col : colonne ou expression SQL du budget
    Comportement :
        - Retourne NULL si budget est NULL ou 0 (pas de base de comparaison).
        - actual_col NULL est traité comme 0 (pas de ventes remontées = 0 réalisé).
        - Résultat arrondi à 2 décimales.
    Exemple d'appel : {{ ecart_pct('ca_reel', 'ca_budget') }}
#}

{% macro ecart_pct(actual_col, budget_col) %}
CASE
    WHEN {{ budget_col }} IS NULL OR {{ budget_col }} = 0 THEN NULL
    ELSE ROUND(
    (COALESCE({{ actual_col }}, 0) - {{ budget_col }}) * 100.0
    / {{ budget_col }}, 2)
END
{% endmacro %}
