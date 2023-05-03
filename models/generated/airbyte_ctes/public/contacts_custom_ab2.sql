{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('contacts_custom_ab1') }}
select
    contactid,
    cast(contact_firstname as {{ dbt_utils.type_string() }}) as contact_firstname,
    cast(contact_lastname as {{ dbt_utils.type_string() }}) as contact_lastname,
    cast(updatedat as {{ dbt_utils.type_string() }}) as updatedat,
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    cast({{ adapter.quote('type') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('type') }},
    {{ adapter.quote('value') }},
    cast(fieldid as {{ dbt_utils.type_bigint() }}) as fieldid,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('contacts_custom_ab1') }}
-- custom at contacts/custom
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}
