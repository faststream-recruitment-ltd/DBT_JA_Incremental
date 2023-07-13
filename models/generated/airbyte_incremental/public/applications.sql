{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "jobadder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('applications_scd') }}
select
    _airbyte_unique_key,
    {{ adapter.quote('source') }},
    manual,
    updatedat,
    owner_userId,
    owner_lastName,
    owner_firstName,
    updatedBy_firstName,
    updatedBy_lastName,
    updatedBy_UserId, 
    jobtitle,
    rating,
    jobreference,
    createdat,
    candidateId,
    candidate_lastName,
    candidate_firstName,
    createdby_firstName,
    createdby_lastName,
    createdby_UserId, 
    jobId,
    job_jobTitle,
    applicationid,
    status_name,
    status_active,
    statusId,
    stageindex,
    stage,
    progress,
    step,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_applications_hashid
from {{ ref('applications_scd') }}
-- applications from {{ source('public', '_airbyte_raw_applications') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

