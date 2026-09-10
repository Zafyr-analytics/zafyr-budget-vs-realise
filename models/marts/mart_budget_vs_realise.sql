WITH c_realise AS (
    SELECT
        mois,
        code_compte,
        centre_cout,
        montant_reel
    FROM
        {{ ref('stg_realise') }}
),
c_budget AS (
    SELECT
        mois,
        code_compte,
        centre_cout,
        montant_budget
    FROM
        {{ ref('stg_budget') }}
),
compare AS (
    SELECT
        COALESCE(r.mois, b.mois) AS mois,
        COALESCE(r.code_compte, b.code_compte) AS code_compte,
        COALESCE(r.centre_cout, b.centre_cout) AS centre_cout,
        ROUND(COALESCE(r.montant_reel, 0), 2) AS montant_reel,
        ROUND(COALESCE(b.montant_budget, 0), 2) AS montant_budget,
        ROUND({{ ecart_budgetaire('r.montant_reel', 'b.montant_budget') }}, 2) AS ecart ,
        {{ ecart_pct('r.montant_reel', 'b.montant_budget') }} AS ecart_pct
    FROM
        c_realise AS r
    FULL OUTER JOIN
        c_budget AS b
    ON
        r.mois = b.mois
        AND r.code_compte = b.code_compte
        AND r.centre_cout = b.centre_cout
),
final AS (
    SELECT
        c.mois,
        c.code_compte,
        c.centre_cout,
        c.montant_reel,
        c.montant_budget,
        c.ecart,
        c.ecart_pct,
        COALESCE(s.libelle_compte, 'Inconnu') AS libelle_compte,
        COALESCE(s.famille, 'Inconnu') AS famille
    FROM
        compare AS c
    LEFT JOIN
        {{ ref('stg_compte') }} AS s
    ON
        c.code_compte = s.code_compte
)

SELECT
    *
FROM
    final
