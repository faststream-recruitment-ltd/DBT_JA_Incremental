{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_job_ads') }}
select
    {{ json_extract_scalar('_airbyte_data', ['owner', 'userId'], ['userId']) }} as owner_userId,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'lastName'], ['lastName']) }} as owner_lastName,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'firstName'], ['firstName']) }} as owner_firstName,
    {{ json_extract_scalar('_airbyte_data', ['summary'], ['summary']) }} as summary,
    {{ json_extract_scalar('_airbyte_data', ['postAt'], ['postAt']) }} as postat,
    {{ json_extract_scalar('_airbyte_data', ['description'], ['description']) }} as description,
    {{ json_extract_scalar('_airbyte_data', ['title'], ['title']) }} as title,
    {{ json_extract_scalar('_airbyte_data', ['expireAt'], ['expireAt']) }} as expireat,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'jobBoards'))->>'name' as jobBoard_name,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'jobBoards'))->>'boardId' as boardId,
    {{ json_extract_scalar('_airbyte_data', ['reference'], ['reference']) }} as reference,
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdat,
    {{ json_extract_scalar('_airbyte_data', ['adId'], ['adId']) }} as adid,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'userId'], ['userId']) }} as createdBy_userId,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'lastName'], ['lastName']) }} as createdBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'firstName'], ['firstName']) }} as createdBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['contact', 'lastName'], ['lastName']) }} as contact_lastName,
    {{ json_extract_scalar('_airbyte_data', ['contact', 'contactId'], ['userId']) }} as contactId,
    {{ json_extract_scalar('_airbyte_data', ['contact', 'firstName'], ['firstName']) }} as contact_firstName,
    {{ json_extract_scalar('_airbyte_data', ['company', 'name'], ['name']) }} as company_name,
    {{ json_extract_scalar('_airbyte_data', ['company', 'companyId'], ['companyId']) }} as companyId,
    {{ json_extract_scalar('_airbyte_data', ['state'], ['state']) }} as {{ adapter.quote('state') }},
    {{ json_extract_scalar('_airbyte_data', ['job', 'jobId'], ['jobId']) }} as jobId,
    {{ json_extract_scalar('_airbyte_data', ['job', 'jobTitle'], ['jobTitle']) }} as job_jobTitle,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_job_ads') }} as table_alias
-- job_ads
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

