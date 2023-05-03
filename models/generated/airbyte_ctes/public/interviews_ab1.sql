{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_interviews') }}
select
    {{ json_extract_scalar('_airbyte_data', ['type'], ['type']) }} as {{ adapter.quote('type') }},
    {{ json_extract_scalar('_airbyte_data', ['startAt'], ['startAt']) }} as startAt,
    {{ json_extract_scalar('_airbyte_data', ['endAt'], ['endAt']) }} as endAt,
    {{ json_extract_scalar('_airbyte_data', ['location'], ['location']) }} as location,
    {{ json_extract_scalar('_airbyte_data', ['interviewId'], ['interviewId']) }} as interviewId,
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdAt,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'email'], ['createdBy_email']) }} as createdBy_email,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'userId'], ['createdBy_userId']) }} as createdBy_userId,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'lastName'], ['createdBy_lastName']) }} as createdBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'firstName'], ['createdBy_firstName']) }} as createdBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'deleted'], ['createdBy_deleted']) }} as createdBy_deleted,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'job', 'jobId'], ['interviewee_job_jobId']) }} as interviewee_job_jobId,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'job', 'status', 'name'], ['interviewee_job_status_name']) }} as interviewee_job_status_name,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'job', 'status', 'statusId'], ['interviewee_job_status_statusId']) }} as interviewee_job_status_statusId,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'source'], ['interviewee_source']) }} as interviewee_source,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'status', 'name'], ['interviewee_status_name']) }} as interviewee_status_name,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'status', 'rejected'], ['interviewee_status_rejected']) }} as interviewee_status_rejected,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'status', 'statusId'], ['interviewee_status_statusId']) }} as interviewee_status_statusId,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'jobTitle'], ['interviewee_jobTitle']) }} as interviewee_jobTitle,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'email'], ['interviewee_candidate_email']) }} as interviewee_candidate_email,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'status', 'name'], ['interviewee_candidate_status_name']) }} as interviewee_candidate_status_name,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'status', 'statusId'], ['interviewee_candidate_status_statusId']) }} as interviewee_candidate_status_statusId,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'lastName'], ['interviewee_candidate_lastName']) }} as interviewee_candidate_lastName,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'firstName'], ['interviewee_candidate_firstName']) }} as interviewee_candidate_firstName,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'candidateId'], ['interviewee_candidate_candidateId']) }} as interviewee_candidate_candidateId,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'candidate', 'source'], ['interviewee_candidate_source']) }} as interviewee_candidate_source,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'jobReference'], ['interviewee_jobReference']) }} as interviewee_jobReference,
    {{ json_extract_scalar('_airbyte_data', ['interviewee', 'applicationId'], ['interviewee_applicationId']) }} as interviewee_applicationId,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_interviews') }} as table_alias
-- interviews
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

