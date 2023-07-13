{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_applications') }}
select
    {{ json_extract_scalar('_airbyte_data', ['owner', 'userId'], ['owner_userId']) }} as owner_userId,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'firstName'], ['owner_firstName']) }} as owner_firstName,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'lastName'], ['owner_lastName']) }} as owner_lastName,
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'userId'], ['updatedBy_userId']) }} as updatedBy_userId,
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'firstName'], ['updatedBy_firstName']) }} as updatedBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'lastName'], ['updatedBy_lastName']) }} as updatedBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['jobTitle'], ['jobTitle']) }} as jobtitle,
    {{ json_extract_scalar('_airbyte_data', ['rating'], ['rating']) }} as rating,
    {{ json_extract_scalar('_airbyte_data', ['source'], ['source']) }} as {{ adapter.quote('source') }},
    {{ json_extract_scalar('_airbyte_data', ['manual'], ['manual']) }} as manual,
    {{ json_extract_scalar('_airbyte_data', ['jobReference'], ['jobReference']) }} as jobreference,
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdat,
    {{ json_extract_scalar('_airbyte_data', ['candidate', 'candidateId'], ['candidate_candidateId']) }} as candidateId,
    {{ json_extract_scalar('_airbyte_data', ['candidate', 'lastName'], ['candidate_lastName']) }} as candidate_lastName,
    {{ json_extract_scalar('_airbyte_data', ['candidate', 'firstName'], ['candidate_firstName']) }} as candidate_firstName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'userId'], ['createdBy_userId']) }} as createdBy_userId,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'firstName'], ['createdBy_firstName']) }} as createdBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'lastName'], ['createdBy_lastName']) }} as createdBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['job', 'jobId'], ['jobId']) }} as jobId,
    {{ json_extract_scalar('_airbyte_data', ['job', 'jobTitle'], ['job_jotTitle']) }} as job_jobTitle,
    {{ json_extract_scalar('_airbyte_data', ['applicationId'], ['applicationId']) }} as applicationid,
    {{ json_extract_scalar('_airbyte_data', ['status', 'name'], ['status_name']) }} as status_name,
    {{ json_extract_scalar('_airbyte_data', ['status', 'active'], ['status_active']) }} as status_active,
    {{ json_extract_scalar('_airbyte_data', ['status', 'statusId'], ['statusId']) }} as statusId,    
    {{ json_extract_scalar('_airbyte_data', ['status', 'workflow', 'stageIndex'], ['stageindex']) }} as stageindex,
    {{ json_extract_scalar('_airbyte_data', ['status', 'workflow', 'stage'], ['stage']) }} as stage,
    {{ json_extract_scalar('_airbyte_data', ['status', 'workflow', 'progress'], ['progress']) }} as progress,
    {{ json_extract_scalar('_airbyte_data', ['status', 'workflow', 'step'], ['step']) }} as step,
    {{ json_extract_scalar('_airbyte_data', ['updatedAt'], ['updatedAt']) }} as updatedat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_applications') }} as table_alias
-- applications
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

