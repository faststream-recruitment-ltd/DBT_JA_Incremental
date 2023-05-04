{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('companies_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'company_name',
        'owner_email',
        'owner_userId',
        'owner_lastName',
        'owner_firstName',
        'owner_deleted',
        'social_twitter',
        'social_linkedin',
        'social_facebook',
        'status_name',
        'status_statusId',
        'companyId',
        'createdAt',
        'createdBy_email',
        'createdBy_userId',
        'createdBy_lastName',
        'createdBy_firstName',
        'createdBy_deleted',
        'updatedAt',
        'updatedBy_email',
        'updatedBy_userId',
        'updatedBy_lastName',
        'updatedBy_firstName',
        'updatedBy_deleted',
        'primaryAddress_url',
        'primaryAddress_city',
        'primaryAddress_name',
        'primaryAddress_phone',
        'primaryAddress_street',
        'primaryAddress_state',
        'primaryAddress_country',
        'primaryAddress_postcode',
        'primaryAddress_addressId',
        'primaryAddress_postalCode',
        'primaryAddress_countryCode',
        'legalName',
        'mainContact_lastName',
        'mainContact_contactId',
        'mainContact_firstName',
        'mainContact_email'
    ]) }} as _airbyte_companies_hashid,
    tmp.*
from {{ ref('companies_ab2') }} tmp
-- companies
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

