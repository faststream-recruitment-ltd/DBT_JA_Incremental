{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "JobAdder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('companies_scd') }}
select
    _airbyte_unique_key,
    companyId,
    company_name,
    owner_email,
    owner_userId,
    owner_lastName,
    owner_firstName,
    owner_deleted,
    social_twitter,
    social_linkedin,
    social_facebook,
    status_name,
    status_statusId,
    createdAt,
    createdBy_email,
    createdBy_userId,
    createdBy_lastName,
    createdBy_firstName,
    createdBy_deleted,
    updatedAt,
    updatedBy_email,
    updatedBy_userId,
    updatedBy_lastName,
    updatedBy_firstName,
    updatedBy_deleted,
    primaryAddress_url,
    primaryAddress_city,
    primaryAddress_name,
    primaryAddress_phone,
    primaryAddress_street,
    primaryAddress_state,
    primaryAddress_country,
    primaryAddress_postcode,
    primaryAddress_addressId,
    primaryAddress_postalCode,
    primaryAddress_countryCode,
    legalName,
    mainContact_lastName,
    mainContact_contactId,
    mainContact_firstName,
    mainContact_email,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_companies_hashid
from {{ ref('companies_scd') }}
-- companies from {{ source('public', '_airbyte_raw_companies') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

