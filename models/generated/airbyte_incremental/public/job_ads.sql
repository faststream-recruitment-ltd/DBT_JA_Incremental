{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "jobadder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('job_ads_scd') }}
select
    _airbyte_unique_key,
    owner_userId,
    owner_lastName,
    owner_firstName,
    summary,
    postat,
    description,
    title,
    expireat,
    jobBoard_name,
    boardId,
    reference,
    createdat,
    adid,
    createdBy_userId,
    createdBy_lastName,
    createdBy_firstName,
    contact_lastName,
    contactId,
    contact_firstName,
    company_name,
    companyId,
    jobId,
    job_jobTitle,
    {{ adapter.quote('state') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_job_ads_hashid
from {{ ref('job_ads_scd') }}
-- job_ads from {{ source('public', '_airbyte_raw_job_ads') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

