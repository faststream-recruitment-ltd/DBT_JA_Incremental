{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "jobadder",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('notes_scd') }}
select
    _airbyte_unique_key,
    _airbyte_notes_hashid,    
    noteid,    
    {{ adapter.quote('type') }},
    reference,
    {{ adapter.quote('source') }},
    updatedat,
    createdat,
    createdBy_userId,
    createdBy_email,
    createdBy_firstName,
    createdBy_lastName,
    jobId,
    jobs_company_name,
    jobs_companyId,
    jobtitle,
    companyId,
    company_name,
    placementId,
    placement_jobId,
    placement_jobTitle,
    placement_company,
    placement_companyId,
    placement_contactId,
    placement_contact_firstName,
    placement_contact_lastName,
    placement_candidateId,
    placement_firstName,
    placement_lastName,     
    candidates,
    contacts,
    applications,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('notes_scd') }}
-- notes from {{ source('public', '_airbyte_raw_notes') }}
where 1 = 1
and _airbyte_active_row = 1
AND type IN (
        'Contact Meeting - Face to Face',
        'Contact Meeting - Video',
        'CV Submitted to Job',
        'CV Submitted to job',
        'CV Submitted via Portal',
        'CV submitted via portal',
        'Float By Email',
        'Float by email',
        'Floated by email',
        'Interview',
        'Left Voicemail/No Contact',
        'Phone Call',
        'Phone Call – Business Development',
        'Phone Call – business Development',
        'Phone Call – Control',
        'Resume Submitted'
    )
    AND source NOT LIKE '%Status%'
{{ incremental_clause('_airbyte_emitted_at', this) }}

