{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('applications_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('source'),
        boolean_to_string('manual'),
        'updatedat',
        'owner_userId',
        'owner_lastName',
        'owner_firstName',
        'updatedBy_firstName',
        'updatedBy_lastName',
        'updatedBy_UserId', 
        'jobtitle',
        'rating',
        'jobreference',
        'createdat',
        'candidateId',
        'candidate_lastName',
        'candidate_firstName',
        'createdby_firstName',
        'createdby_lastName',
        'createdby_UserId', 
        'jobId',
        'job_jobTitle',
        'applicationid',
        'status_name',
        'status_active',
        'statusId',
        'stageindex',
        'stage',
        'progress',
        'step',
    ]) }} as _airbyte_applications_hashid,
    tmp.*
from {{ ref('applications_ab2') }} tmp
-- applications
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

