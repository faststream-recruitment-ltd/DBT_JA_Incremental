{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "Staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('placements_custom_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'placementId',
        'updatedat',
        adapter.quote('name'),
        adapter.quote('type'),
        adapter.quote('value'),
        'fieldid',
    ]) }} as _airbyte_custom_hashid,
    tmp.*
from {{ ref('placements_custom_ab2') }} tmp
-- custom at placements/custom
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}


