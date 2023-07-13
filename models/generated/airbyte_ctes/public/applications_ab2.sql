{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('applications_ab1') }}
select
    cast(owner_userId as {{ dbt_utils.type_bigint() }}) as owner_userId,
    cast(owner_lastName as {{ dbt_utils.type_string() }}) as owner_lastName,
    cast(owner_firstName as {{ dbt_utils.type_string() }}) as owner_firstName,
    cast(updatedBy_firstName as {{ dbt_utils.type_string() }}) as updatedBy_firstName,
    cast(updatedBy_lastName as {{ dbt_utils.type_string() }}) as updatedBy_lastName,
    cast(updatedBy_UserId as {{ dbt_utils.type_bigint() }}) as updatedBy_UserId, 
    cast(jobtitle as {{ dbt_utils.type_string() }}) as jobtitle,
    cast(rating as {{ dbt_utils.type_float() }}) as rating,
    cast({{ adapter.quote('source') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('source') }},
    {{ cast_to_boolean('manual') }} as manual,
    cast(jobreference as {{ dbt_utils.type_string() }}) as jobreference,
    cast(createdat as timestamp) as createdat,
    cast(candidateId as {{ dbt_utils.type_bigint() }}) as candidateId,
    cast(candidate_lastName as {{ dbt_utils.type_string() }}) as candidate_lastName,
    cast(candidate_firstName as {{ dbt_utils.type_string() }}) as candidate_firstName,
    cast(createdby_firstName as {{ dbt_utils.type_string() }}) as createdby_firstName,
    cast(createdby_lastName as {{ dbt_utils.type_string() }}) as createdby_lastName,
    cast(createdby_UserId as {{ dbt_utils.type_bigint() }}) as createdby_UserId, 
    cast(jobId as {{ dbt_utils.type_bigint() }}) as jobId,
    cast(job_jobTitle as {{ dbt_utils.type_string() }}) as job_jobTitle,
    cast(applicationid as {{ dbt_utils.type_bigint() }}) as applicationid,
    cast(status_name as {{ dbt_utils.type_string() }}) as status_name,
    cast(status_active as {{ dbt_utils.type_string() }}) as status_active,
    cast(statusId as {{ dbt_utils.type_bigint() }}) as statusId,
    cast(stageindex as {{ dbt_utils.type_bigint() }}) as stageindex,
    cast(stage as {{ dbt_utils.type_string() }}) as stage,
    cast(progress as {{ dbt_utils.type_string() }}) as progress,
    cast(step as {{ dbt_utils.type_string() }}) as step,
    cast(updatedat as timestamp) as updatedat,    
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('applications_ab1') }}
-- applications
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

