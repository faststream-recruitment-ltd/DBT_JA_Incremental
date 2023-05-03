{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "JobAdder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('contacts_scd') }}
select
    _airbyte_unique_key,
    createdat,
    updatedat,
    contactid,
    salutation,
    firstname,
    lastname,   
    email,
    inactive,
    unsubscribed,
    phone,
    mobile,
    owner_firstName,
    owner_userId, 
    owner_email, 
    status_name,     
    statusid,
    company_name,
    companyid,
    country,
    city,
    street,
    countrycode,
    postalcode,
    postcode,
    state,
    twitter,
    linkedin,
    facebook,
    createdby_firstName,
    createdby_lastName,
    createdby_userId, 
    createdby_email, 
    updatedBy_firstName,
    updatedBy_lastName,
    updatedBy_userId, 
    updatedBy_email, 
    original_contactid,
    previous_contactid,
    reportsTo_firstName,
    reportsTo_lastName,
    reportsTo_contactid, 
    reportsTo_email,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_contacts_hashid
from {{ ref('contacts_scd') }}
-- contacts from {{ source('public', '_airbyte_raw_contacts') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

