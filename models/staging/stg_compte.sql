SELECT
    code_compte,
    libelle_compte,
    famille
FROM
    {{ ref ('ref_comptes')}}
