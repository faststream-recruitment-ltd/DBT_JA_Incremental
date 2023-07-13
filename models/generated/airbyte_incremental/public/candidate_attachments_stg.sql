{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "staging",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('candidate_attachments_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'createdat',
        'filename',
        'createdby_firstName',
        'createdby_lastName',
        'createdby_UserId', 
        'attachmentid',
        adapter.quote('type'),
        'category',
        'candidateid',
        'filetype',
        'updatedat',
    ]) }} as _airbyte_candidate_attachments_hashid,
    tmp.*
from {{ ref('candidate_attachments_ab2') }} tmp
-- candidate_attachments
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

