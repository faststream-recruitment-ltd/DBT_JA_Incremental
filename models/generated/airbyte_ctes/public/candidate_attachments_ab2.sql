{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('candidate_attachments_ab1') }}
select
    cast(createdat as {{ dbt_utils.type_string() }}) as createdat,
    cast(filename as {{ dbt_utils.type_string() }}) as filename,
    cast(createdby_firstName as {{ dbt_utils.type_string() }}) as createdby_firstName,
    cast(createdby_lastName as {{ dbt_utils.type_string() }}) as createdby_lastName,
    cast(createdby_UserId as {{ dbt_utils.type_bigint() }}) as createdby_UserId, 
    cast(attachmentid as {{ dbt_utils.type_float() }}) as attachmentid,
    cast({{ adapter.quote('type') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('type') }},
    cast(category as {{ dbt_utils.type_string() }}) as category,
    cast(candidateid as {{ dbt_utils.type_float() }}) as candidateid,
    cast(filetype as {{ dbt_utils.type_string() }}) as filetype,
    cast(updatedat as {{ dbt_utils.type_string() }}) as updatedat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('candidate_attachments_ab1') }}
-- candidate_attachments
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

