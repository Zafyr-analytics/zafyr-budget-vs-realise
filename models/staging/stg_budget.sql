select
    mois,
    code_compte,
    libelle_compte,
    centre_cout,
    montant_budget
from
    {{ ref('budget') }}

