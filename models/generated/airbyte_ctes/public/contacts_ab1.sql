{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('public', '_airbyte_raw_contacts') }}
select
    {{ json_extract_scalar('_airbyte_data', ['createdAt'], ['createdAt']) }} as createdat,
    {{ json_extract_scalar('_airbyte_data', ['updatedAt'], ['updatedAt']) }} as updatedat,
    {{ json_extract_scalar('_airbyte_data', ['contactId'], ['contactId']) }} as contactid,
    {{ json_extract_scalar('_airbyte_data', ['salutation'], ['salutation']) }} as salutation,
    {{ json_extract_scalar('_airbyte_data', ['firstName'], ['firstName']) }} as firstName,
    {{ json_extract_scalar('_airbyte_data', ['lastName'], ['lastName']) }} as lastName,    
    {{ json_extract_scalar('_airbyte_data', ['email'], ['email']) }} as email,
    {{ json_extract_scalar('_airbyte_data', ['inactive'], ['inactive']) }} as inactive,
    {{ json_extract_scalar('_airbyte_data', ['unsubscribed'], ['unsubscribed']) }} as unsubscribed,
    {{ json_extract_scalar('_airbyte_data', ['phone'], ['phone']) }} as phone,
    {{ json_extract_scalar('_airbyte_data', ['mobile'], ['mobile']) }} as mobile,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'email'], ['email']) }} as owner_email,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'userId'], ['userId']) }} as owner_userId,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'firstName'], ['firstName']) }} as owner_firstName,
    {{ json_extract_scalar('_airbyte_data', ['owner', 'lastName'], ['lastName']) }} as owner_lastName,
    {{ json_extract_scalar('_airbyte_data', ['status', 'name'], ['name']) }} as status_name,
    {{ json_extract_scalar('_airbyte_data', ['status', 'statusId'], ['statusId']) }} as statusId,
    {{ json_extract_scalar('_airbyte_data', ['company', 'name'], ['name']) }} as company_name,
    {{ json_extract_scalar('_airbyte_data', ['company', 'companyId'], ['companyId']) }} as companyid,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'country'], ['country']) }} as country,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'city'], ['city']) }} as city,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'street'], ['street']) }} as street,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'countrycode'], ['countrycode']) }} as countrycode,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'postalcode'], ['postalcode']) }} as postalcode,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'postcode'], ['postcode']) }} as postcode,
    {{ json_extract_scalar('_airbyte_data', ['officeAddress', 'state'], ['state']) }} as state,
    {{ json_extract_scalar('_airbyte_data', ['social', 'twitter'], ['twitter']) }} as twitter,
    {{ json_extract_scalar('_airbyte_data', ['social', 'linkedin'], ['linkedin']) }} as linkedin,
    {{ json_extract_scalar('_airbyte_data', ['social', 'facebook'], ['facebook']) }} as facebook,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'firstName'], ['createdBy_firstName']) }} as createdBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'lastName'], ['createdBy_lastName']) }} as createdBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'userId'], ['createdBy_userId']) }} as createdBy_userId,   
    {{ json_extract_scalar('_airbyte_data', ['createdBy', 'email'], ['createdBy_email']) }} as createdBy_email,  
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'firstName'], ['updatedBy_firstName']) }} as updatedBy_firstName,
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'lastName'], ['updatedBy_lastName']) }} as updatedBy_lastName,
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'userId'], ['updatedBy_userId']) }} as updatedBy_userId,   
    {{ json_extract_scalar('_airbyte_data', ['updatedBy', 'email'], ['updatedBy_email']) }} as updatedBy_email,
    {{ json_extract_scalar('_airbyte_data', ['originalContactId'], ['originalContactId']) }} as original_contactid,
    {{ json_extract_scalar('_airbyte_data', ['previousContactId'], ['previousContactId']) }} as previous_contactid,
    {{ json_extract_scalar('_airbyte_data', ['reportsTo', 'firstName'], ['reportsTo_firstName']) }} as reportsTo_firstName,
    {{ json_extract_scalar('_airbyte_data', ['reportsTo', 'lastName'], ['reportsTo_lastName']) }} as reportsTo_lastName,
    {{ json_extract_scalar('_airbyte_data', ['reportsTo', 'contactId'], ['reportsTo_contactid']) }} as reportsTo_contactid,   
    {{ json_extract_scalar('_airbyte_data', ['reportsTo', 'email'], ['reportsTo_email']) }} as reportsTo_email,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('public', '_airbyte_raw_contacts') }} as table_alias
-- contacts
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

