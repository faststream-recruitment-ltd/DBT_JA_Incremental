{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "Staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('interviews_interviewers_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'type',
        'interviewid',
        'createdat',
        'contact_email',
        'contactid',
        'contact_firstname',
        'contact_lastname',
        'user_email',
        'userid',
        'user_firstname',
        'user_lastname',
    ]) }} as _airbyte_interviewers_hashid,
    tmp.*
from {{ ref('interviews_interviewers_ab2') }} tmp
-- interviewers at interviews/interviewers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}


