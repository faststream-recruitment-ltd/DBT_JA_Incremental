{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('interviews_interviewers_ab1') }}
select
    cast(type as {{ dbt_utils.type_string() }}) as type,
    interviewid,
    cast(createdat as timestamp with time zone) as createdat,
    cast(contact_email as {{ dbt_utils.type_string() }}) as contact_email,
    cast(contactid as {{ dbt_utils.type_string() }}) as contactid,
    cast(contact_firstname as {{ dbt_utils.type_string() }}) as contact_firstname,
    cast(contact_lastname as {{ dbt_utils.type_string() }}) as contact_lastname,
    cast(user_email as {{ dbt_utils.type_string() }}) as user_email,
    cast(userid as {{ dbt_utils.type_string() }}) as userid,
    cast(user_firstname as {{ dbt_utils.type_string() }}) as user_firstname,
    cast(user_lastname as {{ dbt_utils.type_string() }}) as user_lastname,        
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('interviews_interviewers_ab1') }}
-- interviewers at interviews/interviewers
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}