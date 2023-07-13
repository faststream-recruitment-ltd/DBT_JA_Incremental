{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('job_ads_ab2') }}
select
    {{ dbt_utils.surrogate_key([        
        'owner_userId',
        'owner_lastName',
        'owner_firstName',
        'summary',
        'postat',
        'description',
        'title',
        'expireat',
        'jobBoard_name',
        'boardId',
        'reference',
        'createdat',
        'adid',
        'createdBy_userId',
        'createdBy_lastName',
        'createdBy_firstName',
        'contact_lastName',
        'contactId',
        'contact_firstName',
        'company_name',
        'companyId',
        adapter.quote('state'),
        'jobId',
        'job_jobTitle',
    ]) }} as _airbyte_job_ads_hashid,
    tmp.*
from {{ ref('job_ads_ab2') }} tmp
-- job_ads
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

