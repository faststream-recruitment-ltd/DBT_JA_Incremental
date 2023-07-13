{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "jobadder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('jobs_custom_scd') }}
select
    _airbyte_unique_key,
    jobId,
    jobTitle,
    updatedat,
    {{ adapter.quote('name') }},
    {{ adapter.quote('type') }},
    {{ adapter.quote('value') }},
    fieldid,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_custom_hashid
from {{ ref('jobs_custom_scd') }}
-- custom from {{ source('public', '_airbyte_raw_jobs') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}