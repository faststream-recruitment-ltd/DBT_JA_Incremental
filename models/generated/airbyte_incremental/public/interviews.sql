{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "JobAdder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('interviews_scd') }}
select
    _airbyte_unique_key,
    type,
    startAt,
    endAt,
    location,
    interviewId,
    createdAt,
    createdBy_email,
    createdBy_userId,
    createdBy_lastName,
    createdBy_firstName,
    createdBy_deleted,
    interviewee_job_jobId,
    interviewee_job_status_name,
    interviewee_job_status_statusId,
    interviewee_source,
    interviewee_status_name,
    interviewee_status_rejected,
    interviewee_status_statusId,
    interviewee_jobTitle,
    interviewee_candidate_email,
    interviewee_candidate_status_name,
    interviewee_candidate_status_statusId,
    interviewee_candidate_lastName,
    interviewee_candidate_firstName,
    interviewee_candidate_candidateId,
    interviewee_candidate_source,
    interviewee_jobReference,
    interviewee_applicationId,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_interviews_hashid
from {{ ref('interviews_scd') }}
-- interviews from {{ source('public', '_airbyte_raw_interviews') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

