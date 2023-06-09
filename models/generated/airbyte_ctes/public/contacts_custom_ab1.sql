{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_contacts') }}
select
    {{ json_extract_scalar('_airbyte_data', ['contactId'], ['contactId']) }} as contactid,
    {{ json_extract_scalar('_airbyte_data', ['firstName'], ['firstName']) }} as contact_firstname,
    {{ json_extract_scalar('_airbyte_data', ['lastName'], ['lastName']) }} as contact_lastname,
    {{ json_extract_scalar('_airbyte_data', ['updatedAt'], ['updatedAt']) }} as updatedat,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'custom'))->>'name' as name,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'custom'))->>'type' as type,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'custom'))->>'value' as value,
    jsonb_array_elements(jsonb_extract_path(_airbyte_data, 'custom'))->>'fieldId' as fieldId,    
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_contacts') }} as table_alias
-- contact_custom
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}