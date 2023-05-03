{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('interviews_ab1') }}
select
    cast(type as {{ dbt_utils.type_string() }}) as type,
    cast(startAt as {{ dbt_utils.type_string() }}) as startAt,
    cast(endAt as {{ dbt_utils.type_string() }}) as endAt,
    cast(location as {{ dbt_utils.type_string() }}) as location,
    cast(interviewId as {{ dbt_utils.type_string() }}) as interviewId,
    cast(createdAt as {{ dbt_utils.type_string() }}) as createdAt,
    cast(createdBy_email as {{ dbt_utils.type_string() }}) as createdBy_email,
    cast(createdBy_userId as {{ dbt_utils.type_string() }}) as createdBy_userId,
    cast(createdBy_lastName as {{ dbt_utils.type_string() }}) as createdBy_lastName,
    cast(createdBy_firstName as {{ dbt_utils.type_string() }}) as createdBy_firstName,
    cast(createdBy_deleted as {{ dbt_utils.type_string() }}) as createdBy_deleted,
    cast(interviewee_job_jobId as {{ dbt_utils.type_string() }}) as interviewee_job_jobId,
    cast(interviewee_job_status_name as {{ dbt_utils.type_string() }}) as interviewee_job_status_name,
    cast(interviewee_job_status_statusId as {{ dbt_utils.type_string() }}) as interviewee_job_status_statusId,
    cast(interviewee_source as {{ dbt_utils.type_string() }}) as interviewee_source,
    cast(interviewee_status_name as {{ dbt_utils.type_string() }}) as interviewee_status_name,
    cast(interviewee_status_rejected as {{ dbt_utils.type_string() }}) as interviewee_status_rejected,
    cast(interviewee_status_statusId as {{ dbt_utils.type_string() }}) as interviewee_status_statusId,
    cast(interviewee_jobTitle as {{ dbt_utils.type_string() }}) as interviewee_jobTitle,
    cast(interviewee_candidate_email as {{ dbt_utils.type_string() }}) as interviewee_candidate_email,
    cast(interviewee_candidate_status_name as {{ dbt_utils.type_string() }}) as interviewee_candidate_status_name,
    cast(interviewee_candidate_status_statusId as {{ dbt_utils.type_string() }}) as interviewee_candidate_status_statusId,
    cast(interviewee_candidate_lastName as {{ dbt_utils.type_string() }}) as interviewee_candidate_lastName,
    cast(interviewee_candidate_firstName as {{ dbt_utils.type_string() }}) as interviewee_candidate_firstName,
    cast(interviewee_candidate_candidateId as {{ dbt_utils.type_string() }}) as interviewee_candidate_candidateId,
    cast(interviewee_candidate_source as {{ dbt_utils.type_string() }}) as interviewee_candidate_source,
    cast(interviewee_jobReference as {{ dbt_utils.type_string() }}) as interviewee_jobReference,
    cast(interviewee_applicationId as {{ dbt_utils.type_string() }}) as interviewee_applicationId,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('interviews_ab1') }}
-- interviews
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}