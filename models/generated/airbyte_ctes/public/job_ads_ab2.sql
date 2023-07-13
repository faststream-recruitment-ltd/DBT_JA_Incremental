{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('job_ads_ab1') }}
select
    cast(owner_userId as {{ dbt_utils.type_bigint() }}) as owner_userId,
    cast(owner_lastName as {{ dbt_utils.type_string() }}) as owner_lastName,
    cast(owner_firstName as {{ dbt_utils.type_string() }}) as owner_firstName,
    cast(summary as {{ dbt_utils.type_string() }}) as summary,
    cast(postat as timestamp) as postat,
    cast(description as {{ dbt_utils.type_string() }}) as description,
    cast(title as {{ dbt_utils.type_string() }}) as title,
    cast(expireat as timestamp) as expireat,
    cast(jobBoard_name as {{ dbt_utils.type_string() }}) as jobBoard_name,
    cast(boardId as {{ dbt_utils.type_bigint() }}) as boardId,
    cast(reference as {{ dbt_utils.type_string() }}) as reference,
    cast(createdat as timestamp) createdat,
    cast(adid as {{ dbt_utils.type_bigint() }}) as adid,
    cast(createdBy_userId as {{ dbt_utils.type_string() }}) as createdBy_userId,
    cast(createdBy_lastName as {{ dbt_utils.type_string() }}) as createdBy_lastName,
    cast(createdBy_firstName as {{ dbt_utils.type_string() }}) as createdBy_firstName,
    cast(contact_lastName as {{ dbt_utils.type_string() }}) as contact_lastName,
    cast(contactId as {{ dbt_utils.type_bigint() }}) as contactId,
    cast(contact_firstName as {{ dbt_utils.type_string() }}) as contact_firstName,
    cast(company_name as {{ dbt_utils.type_string() }}) as company_name,
    cast(companyId as {{ dbt_utils.type_bigint() }}) as companyId,
    cast({{ adapter.quote('state') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('state') }},
    cast(jobId as {{ dbt_utils.type_bigint() }}) as jobId,
    cast(job_jobTitle as {{ dbt_utils.type_string() }}) as job_jobTitle,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('job_ads_ab1') }}
-- job_ads
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

