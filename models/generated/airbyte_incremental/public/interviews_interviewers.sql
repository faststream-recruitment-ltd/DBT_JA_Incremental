{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "JobAdder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('interviews_interviewers_scd') }}
select
    _airbyte_unique_key,
    interviewid,
    type,
    createdat,
    contact_email,
    contactid,
    contact_firstname,
    contact_lastname,
    user_email,
    userid,
    user_firstname,
    user_lastname,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_interviewers_hashid
from {{ ref('interviews_interviewers_scd') }}
-- recruiters from {{ source('public', '_airbyte_raw_interviews') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}