{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_interviews') }}
select
    {{ json_extract_scalar('_airbyte_data', ['type'], ['type']) }} as type,
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdat,
    {{ json_extract_scalar('_airbyte_data', ['interviewId'], ['interviewId']) }} as interviewid,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'contacts'))->>'contactId' as contactid,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'contacts'))->>'email' as contact_email,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'contacts'))->>'firstName' as contact_firstname,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'contacts'))->>'lastName' as contact_lastname,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'users'))->>'userId' as userid,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'users'))->>'email' as user_email,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'users'))->>'firstName' as user_firstname,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'interviewers', 'users'))->'lastName' as user_lastname,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_interviews') }}  as table_alias
-- interviews_interviewers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}