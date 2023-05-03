{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('companies_ab1') }}
select
    cast(company_name as {{ dbt_utils.type_string() }}) as company_name,
    cast(owner_email as {{ dbt_utils.type_string() }}) as owner_email,
    cast(owner_userId as {{ dbt_utils.type_string() }}) as owner_userId,
    cast(owner_lastName as {{ dbt_utils.type_string() }}) as owner_lastName,
    cast(owner_firstName as {{ dbt_utils.type_string() }}) as owner_firstName,
    cast(owner_deleted as {{ dbt_utils.type_string() }}) as owner_deleted,
    cast(social_twitter as {{ dbt_utils.type_string() }}) as social_twitter,
    cast(social_linkedin as {{ dbt_utils.type_string() }}) as social_linkedin,
    cast(social_facebook as {{ dbt_utils.type_string() }}) as social_facebook,
    cast(status_name as {{ dbt_utils.type_string() }}) as status_name,
    cast(status_statusId as {{ dbt_utils.type_string() }}) as status_statusId,
    cast(companyId as {{ dbt_utils.type_string() }}) as companyId,
    cast(createdAt as {{ dbt_utils.type_string() }}) as createdAt,
    cast(createdBy_email as {{ dbt_utils.type_string() }}) as createdBy_email,
    cast(createdBy_userId as {{ dbt_utils.type_string() }}) as createdBy_userId,
    cast(createdBy_lastName as {{ dbt_utils.type_string() }}) as createdBy_lastName,
    cast(createdBy_firstName as {{ dbt_utils.type_string() }}) as createdBy_firstName,
    cast(createdBy_deleted as {{ dbt_utils.type_string() }}) as createdBy_deleted,
    cast(updatedAt as {{ dbt_utils.type_string() }}) as updatedAt,
    cast(updatedBy_email as {{ dbt_utils.type_string() }}) as updatedBy_email,
    cast(updatedBy_userId as {{ dbt_utils.type_string() }}) as updatedBy_userId,
    cast(updatedBy_lastName as {{ dbt_utils.type_string() }}) as updatedBy_lastName,
    cast(updatedBy_firstName as {{ dbt_utils.type_string() }}) as updatedBy_firstName,
    cast(updatedBy_deleted as {{ dbt_utils.type_string() }}) as updatedBy_deleted,
    cast(primaryAddress_url as {{ dbt_utils.type_string() }}) as primaryAddress_url,
    cast(primaryAddress_city as {{ dbt_utils.type_string() }}) as primaryAddress_city,
    cast(primaryAddress_name as {{ dbt_utils.type_string() }}) as primaryAddress_name,
    cast(primaryAddress_phone as {{ dbt_utils.type_string() }}) as primaryAddress_phone,
    cast(primaryAddress_street as {{ dbt_utils.type_string() }}) as primaryAddress_street,
    cast(primaryAddress_state as {{ dbt_utils.type_string() }}) as primaryAddress_state,
    cast(primaryAddress_country as {{ dbt_utils.type_string() }}) as primaryAddress_country,
    cast(primaryAddress_postcode as {{ dbt_utils.type_string() }}) as primaryAddress_postcode,
    cast(primaryAddress_addressId as {{ dbt_utils.type_string() }}) as primaryAddress_addressId,
    cast(primaryAddress_postalCode as {{ dbt_utils.type_string() }}) as primaryAddress_postalCode,
    cast(primaryAddress_countryCode as {{ dbt_utils.type_string() }}) as primaryAddress_countryCode,
    cast(legalName as {{ dbt_utils.type_string() }}) as legalName,
    cast(mainContact_lastName as {{ dbt_utils.type_string() }}) as mainContact_lastName,
    cast(mainContact_contactId as {{ dbt_utils.type_string() }}) as mainContact_contactId,
    cast(mainContact_firstName as {{ dbt_utils.type_string() }}) as mainContact_firstName,
    cast(mainContact_email as {{ dbt_utils.type_string() }}) as mainContact_email,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('companies_ab1') }}
-- companies
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}