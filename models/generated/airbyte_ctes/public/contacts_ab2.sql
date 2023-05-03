{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('contacts_ab1') }}
select
    cast(createdat as {{ dbt_utils.type_string() }}) as createdat,
    cast(updatedat as {{ dbt_utils.type_string() }}) as updatedat,
    cast(contactid as {{ dbt_utils.type_bigint() }}) as contactid,
    cast(salutation as {{ dbt_utils.type_string() }}) as salutation,
    cast(firstname as {{ dbt_utils.type_string() }}) as firstname,
    cast(lastname as {{ dbt_utils.type_string() }}) as lastname,   
    cast(email as {{ dbt_utils.type_string() }}) as email,
    cast(inactive as {{ dbt_utils.type_string() }}) as inactive,
    cast(unsubscribed as {{ dbt_utils.type_string() }}) as unsubscribed,
    cast(phone as {{ dbt_utils.type_string() }}) as phone,
    cast(mobile as {{ dbt_utils.type_string() }}) as mobile,
    cast(owner_firstName as {{ dbt_utils.type_string() }}) as owner_firstName,
    cast(owner_lastName as {{ dbt_utils.type_string() }}) as owner_lastName,
    cast(owner_userId as {{ dbt_utils.type_string() }}) as owner_userId, 
    cast(owner_email as {{ dbt_utils.type_string() }}) as owner_email, 
    cast(status_name as {{ dbt_utils.type_string() }}) as status_name,     
    cast(statusid as {{ dbt_utils.type_string() }}) as statusid,
    cast(company_name as {{ dbt_utils.type_string() }}) as company_name,
    cast(companyid as {{ dbt_utils.type_string() }}) as companyid,
    cast(country as {{ dbt_utils.type_string() }}) as country,
    cast(city as {{ dbt_utils.type_string() }}) as city,
    cast(countrycode as {{ dbt_utils.type_string() }}) as street,
    cast(countrycode as {{ dbt_utils.type_string() }}) as countrycode,
    cast(postalcode as {{ dbt_utils.type_string() }}) as postalcode,
    cast(postcode as {{ dbt_utils.type_string() }}) as postcode,
    cast(state as {{ dbt_utils.type_string() }}) as state,
    cast(twitter as {{ dbt_utils.type_string() }}) as twitter,
    cast(linkedin as {{ dbt_utils.type_string() }}) as linkedin,
    cast(facebook as {{ dbt_utils.type_string() }}) as facebook,
    cast(createdby_firstName as {{ dbt_utils.type_string() }}) as createdby_firstName,
    cast(createdby_lastName as {{ dbt_utils.type_string() }}) as createdby_lastName,
    cast(createdby_userId as {{ dbt_utils.type_string() }}) as createdby_userId, 
    cast(createdby_email as {{ dbt_utils.type_string() }}) as createdby_email, 
    cast(updatedBy_firstName as {{ dbt_utils.type_string() }}) as updatedBy_firstName,
    cast(updatedBy_lastName as {{ dbt_utils.type_string() }}) as updatedBy_lastName,
    cast(updatedBy_userId as {{ dbt_utils.type_string() }}) as updatedBy_userId, 
    cast(updatedBy_email as {{ dbt_utils.type_string() }}) as updatedBy_email, 
    cast(original_contactid as {{ dbt_utils.type_string() }}) as original_contactid,
    cast(previous_contactid as {{ dbt_utils.type_string() }}) as previous_contactid,
    cast(reportsTo_firstName as {{ dbt_utils.type_string() }}) as reportsTo_firstName,
    cast(reportsTo_lastName as {{ dbt_utils.type_string() }}) as reportsTo_lastName,
    cast(reportsTo_contactid as {{ dbt_utils.type_string() }}) as reportsTo_contactid, 
    cast(reportsTo_email as {{ dbt_utils.type_string() }}) as reportsTo_email,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('contacts_ab1') }}
-- contacts
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

