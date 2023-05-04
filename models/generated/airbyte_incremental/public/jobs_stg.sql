{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('jobs_ab2') }}
select
    {{ dbt_utils.surrogate_key([
    'fee_currency',
    'fee_rateType',
    'jobId',
    'owner_email',
    'owner_userId',
    'owner_deleted',
    'owner_firstName',
    'owner_lastName',
    'start_date',
    'salary_rateLow',
    'salary_ratePer',
    'salary_currency',
    'salary_rateHigh',
    'status_name',
    'status_active',
    'status_statusId',
    'company_name',
    'company_status_name',
    'company_status_statusId',
    'companyId',    
    'contact_email',
    'contact_status_name',
    'contact_status_statusId',
    'contact_lastName',
    'contact_contactId',
    'contact_firstName',
    'jobType',
    'jobTitle',
    'workType_name',
    'workType_workTypeId',
    'createdAt',
    'updatedAt',
    'statistics_applications_new',
    'statistics_applications_total',
    'statistics_applications_active',
    'numberOfJobs',
    'workplaceAddress_url',
    'workplaceAddress_city',
    'workplaceAddress_name',
    'workplaceAddress_phone',
    'workplaceAddress_street',
    'workplaceAddress_country',
    'workplaceAddress_addressId',
    'workplaceAddress_countryCode',
    'workplaceAddress_state',
    'workplaceAddress_postcode',
    'workplaceAddress_postalCode',
    array_to_string('custom'),
    'source',
    array_to_string('category'),
    'closedAt',
    'closedBy_email',
    'closedBy_userId',
    'closedBy_firstName',
    'closedBy_lastName',
    'closedBy_deleted',
    'location_name',
    'location_locationId',
    'updatedBy_email',
    'updatedBy_userId',
    'updatedBy_firstName',
    'updatedBy_lastName',
    'updatedBy_deleted',
    array_to_string('recruiters'),
    array_to_string('otherContacts'),
    'createdBy_email',
    'createdBy_userId',
    'createdBy_firstName',
    'createdBy_lastName',
    'createdBy_deleted',
    array_to_string('workShift'),
    'jobDescription',
    array_to_string('duration'),
    array_to_string('skillTags'),
    ]) }} as _airbyte_jobs_hashid,
    tmp.*
from {{ ref('jobs_ab2') }} tmp
-- jobs
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}
