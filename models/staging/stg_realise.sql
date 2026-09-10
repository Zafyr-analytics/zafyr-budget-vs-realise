
WITH clean1 AS (
    SELECT
        mois,
        CASE
            WHEN code_compte = 699999 THEN 602000 else code_compte
            END AS code_compte,
        centre_cout,
        montant_reel
FROM
    {{ ref('realise') }}

),
clean_2 AS (
    SELECT
        *,
         ROW_NUMBER() OVER ( PARTITION BY mois, code_compte, centre_cout, montant_reel ORDER BY mois desc ) as rn
    FROM
        clean1
)
SELECT
    mois,
    code_compte,
    centre_cout,
    SUM(montant_reel) AS montant_reel
FROM
    clean_2
WHERE
    rn=1
GROUP BY
        mois,
        code_compte,
        centre_cout



