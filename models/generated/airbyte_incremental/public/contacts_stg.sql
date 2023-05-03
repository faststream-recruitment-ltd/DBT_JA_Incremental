{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "Staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('contacts_ab2') }}
select
    {{ dbt_utils.surrogate_key([
    'createdat',
    'updatedat',
    'contactid',
    'salutation',
    'firstname',
    'lastname',   
    'email',
    'inactive',
    'unsubscribed',
    'phone',
    'mobile',
    'owner_firstName',
    'owner_userId', 
    'owner_email', 
    'status_name',     
    'statusid',
    'company_name',
    'companyid',
    'country',
    'city',
    'street',
    'countrycode',
    'postalcode',
    'postcode',
    'state',
    'twitter',
    'linkedin',
    'facebook',
    'createdby_firstName',
    'createdby_lastName',
    'createdby_userId', 
    'createdby_email', 
    'updatedBy_firstName',
    'updatedBy_lastName',
    'updatedBy_userId', 
    'updatedBy_email', 
    'original_contactid',
    'previous_contactid',
    'reportsTo_firstName',
    'reportsTo_lastName',
    'reportsTo_contactid', 
    'reportsTo_email',
    ]) }} as _airbyte_contacts_hashid,
    tmp.*
from {{ ref('contacts_ab2') }} tmp
-- contacts
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

