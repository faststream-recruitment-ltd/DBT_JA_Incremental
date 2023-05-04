{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "jobadder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('placements_scd') }}
select
    _airbyte_unique_key,
    placementid,
    job_jobId,
    job_source,
    type,
    owner_email,
    owner_userId,
    owner_lastName,
    owner_firstName,
    salary_fee,
    salary_base,
    salary_total,
    status_name,
    status_statusId,
    company_companyId,
    company_name,
    contact_email,
    contact_lastName,
    contact_contactId,
    contact_firstName,
    jobTitle,
    candidate_email,
    candidate_candidateId,
    candidate_lastName,
    candidate_firstName,
    candidate_source,
    createdAt,
    startDate,
    updatedAt,
    recruiters,
    chargeCurrency,
    workplaceAddress_url,
    workplaceAddress_city,
    workplaceAddress_name,
    workplaceAddress_street,
    workplaceAddress_country,
    workplaceAddress_postcode,
    workplaceAddress_postalCode,
    custom,
    updatedBy_email,
    updatedBy_userId,
    updatedBy_lastName,
    updatedBy_firstName,
    paymentType,
    billing_email,
    billing_terms,
    billing_dueDate,
    feeSplit,
    createdBy_email,
    createdBy_userId,
    createdBy_lastName,
    createdBy_firstName,
    contractRate_onCosts,
    contractRate_ratePer,
    contractRate_onCostsType,
    contractRate_candidateRate,
    summary,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_placements_hashid
from {{ ref('placements_scd') }}
-- placements from {{ source('public', '_airbyte_raw_placements') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

