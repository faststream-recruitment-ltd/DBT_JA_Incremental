{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "jobadder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('candidate_attachments_scd') }}
select
    _airbyte_unique_key,
    createdat,
    filename,
    createdby_firstName,
    createdby_lastName,
    createdby_UserId, 
    attachmentid,
    {{ adapter.quote('type') }},
    category,
    candidateid,
    filetype,
    updatedat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_candidate_attachments_hashid
from {{ ref('candidate_attachments_scd') }}
-- candidate_attachments from {{ source('public', '_airbyte_raw_candidate_attachments') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

