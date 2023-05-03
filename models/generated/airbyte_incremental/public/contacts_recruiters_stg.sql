{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "Staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('contacts_custom_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'contactid',
        'contact_firstname',
        'contact_lastname',
        'updatedat',
        'userid',
        'email',
        'firstName',
        'lastName',
    ]) }} as _airbyte_recruiters_hashid,
    tmp.*
from {{ ref('contacts_recruiters_ab2') }} tmp
-- custom at contacts/recruiters
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}


