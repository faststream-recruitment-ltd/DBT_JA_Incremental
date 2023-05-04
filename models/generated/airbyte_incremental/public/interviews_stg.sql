{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('interviews_ab2') }}
select
    {{ dbt_utils.surrogate_key([
    'type',
    'startAt',
    'endAt',
    'location',
    'interviewId',
    'createdAt',
    'createdBy_email',
    'createdBy_userId',
    'createdBy_lastName',
    'createdBy_firstName',
    'createdBy_deleted',
    'interviewee_job_jobId',
    'interviewee_job_status_name',
    'interviewee_job_status_statusId',
    'interviewee_source',
    'interviewee_status_name',
    'interviewee_status_rejected',
    'interviewee_status_statusId',
    'interviewee_jobTitle',
    'interviewee_candidate_email',
    'interviewee_candidate_status_name',
    'interviewee_candidate_status_statusId',
    'interviewee_candidate_lastName',
    'interviewee_candidate_firstName',
    'interviewee_candidate_candidateId',
    'interviewee_candidate_source',
    'interviewee_jobReference',
    'interviewee_applicationId',
    ]) }} as _airbyte_interviews_hashid,
    tmp.*
from {{ ref('interviews_ab2') }} tmp
-- interviews
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

