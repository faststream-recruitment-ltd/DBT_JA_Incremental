{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_candidate_attachments') }}
select
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdat,
    {{ json_extract_scalar('_airbyte_data', ['fileName'], ['fileName']) }} as filename,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'userId'], ['createdBy_userId']) }} as createdBy_userId,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'firstName'], ['createdBy_firstName']) }} as createdBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'lastName'], ['createdBy_lastName']) }} as createdBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['attachmentId'], ['attachmentId']) }} as attachmentid,
    {{ json_extract_scalar('_airbyte_data', ['type'], ['type']) }} as {{ adapter.quote('type') }},
    {{ json_extract_scalar('_airbyte_data', ['category'], ['category']) }} as category,
    {{ json_extract_scalar('_airbyte_data', ['candidateId'], ['candidateId']) }} as candidateid,
    {{ json_extract_scalar('_airbyte_data', ['fileType'], ['fileType']) }} as filetype,
    {{ json_extract_scalar('_airbyte_data', ['updatedAt'], ['updatedAt']) }} as updatedat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_candidate_attachments') }} as table_alias
-- candidate_attachments
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

