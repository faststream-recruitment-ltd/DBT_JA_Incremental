{{ config(
    indexes = [{'columns':['_airbyte_active_row','_airbyte_unique_key_scd','_airbyte_emitted_at'],'type': 'btree'}],
    unique_key = "_airbyte_unique_key_scd",
    schema = "scd",
    post_hook = ["
                    {%
                    set final_table_relation = adapter.get_relation(
                            database=this.database,
                            schema=this.schema,
                            identifier='contacts'
                        )
                    %}
                    {#
                    If the final table doesn't exist, then obviously we can't delete anything from it.
                    Also, after a reset, the final table is created without the _airbyte_unique_key column (this column is created during the first sync)
                    So skip this deletion if the column doesn't exist. (in this case, the table is guaranteed to be empty anyway)
                    #}
                    {%
                    if final_table_relation is not none and '_airbyte_unique_key' in adapter.get_columns_in_relation(final_table_relation)|map(attribute='name')
                    %}
                    -- Delete records which are no longer active:
                    -- This query is equivalent, but the left join version is more performant:
                    -- delete from final_table where unique_key in (
                    --     select unique_key from scd_table where 1 = 1 <incremental_clause(normalized_at, final_table)>
                    -- ) and unique_key not in (
                    --     select unique_key from scd_table where active_row = 1 <incremental_clause(normalized_at, final_table)>
                    -- )
                    -- We're incremental against normalized_at rather than emitted_at because we need to fetch the SCD
                    -- entries that were _updated_ recently. This is because a deleted record will have an SCD record
                    -- which was emitted a long time ago, but recently re-normalized to have active_row = 0.
                    delete from {{ final_table_relation }} where {{ final_table_relation }}._airbyte_unique_key in (
                        select recent_records.unique_key
                        from (
                                select distinct _airbyte_unique_key as unique_key
                                from {{ this }}
                                where 1=1 {{ incremental_clause('_airbyte_normalized_at', adapter.quote(this.schema) + '.' + adapter.quote('contacts')) }}
                            ) recent_records
                            left join (
                                select _airbyte_unique_key as unique_key, count(_airbyte_unique_key) as active_count
                                from {{ this }}
                                where _airbyte_active_row = 1 {{ incremental_clause('_airbyte_normalized_at', adapter.quote(this.schema) + '.' + adapter.quote('contacts')) }}
                                group by _airbyte_unique_key
                            ) active_counts
                            on recent_records.unique_key = active_counts.unique_key
                        where active_count is null or active_count = 0
                    )
                    {% else %}
                    -- We have to have a non-empty query, so just do a noop delete
                    delete from {{ this }} where 1=0
                    {% endif %}
                    ","delete from staging.contacts_stg where _airbyte_emitted_at != (select max(_airbyte_emitted_at) from staging.contacts_stg)"],
    tags = [ "top-level" ]
) }}
-- depends_on: ref('contacts_stg')
with
{% if is_incremental() %}
new_data as (
    -- retrieve incremental "new" data
    select
        *
    from {{ ref('contacts_stg')  }}
    -- contacts from {{ source('public', '_airbyte_raw_contacts') }}
    where 1 = 1
    {{ incremental_clause('_airbyte_emitted_at', this) }}
),
new_data_ids as (
    -- build a subset of _airbyte_unique_key from rows that are new
    select distinct
        {{ dbt_utils.surrogate_key([
            'contactid',
        ]) }} as _airbyte_unique_key
    from new_data
),
empty_new_data as (
    -- build an empty table to only keep the table's column types
    select * from new_data where 1 = 0
),
previous_active_scd_data as (
    -- retrieve "incomplete old" data that needs to be updated with an end date because of new changes
    select
        {{ star_intersect(ref('contacts_stg'), this, from_alias='inc_data', intersect_alias='this_data') }}
    from {{ this }} as this_data
    -- make a join with new_data using primary key to filter active data that need to be updated only
    join new_data_ids on this_data._airbyte_unique_key = new_data_ids._airbyte_unique_key
    -- force left join to NULL values (we just need to transfer column types only for the star_intersect macro on schema changes)
    left join empty_new_data as inc_data on this_data._airbyte_ab_id = inc_data._airbyte_ab_id
    where _airbyte_active_row = 1
),
input_data as (
    select {{ dbt_utils.star(ref('contacts_stg')) }} from new_data
    union all
    select {{ dbt_utils.star(ref('contacts_stg')) }} from previous_active_scd_data
),
{% else %}
input_data as (
    select *
    from {{ ref('contacts_stg')  }}
    -- contacts from {{ source('public', '_airbyte_raw_contacts') }}
),
{% endif %}
scd_data as (
    -- SQL model to build a Type 2 Slowly Changing Dimension (SCD) table for each record identified by their primary key
    select
      {{ dbt_utils.surrogate_key([
      'contactid',
      ]) }} as _airbyte_unique_key,
      createdat,
      updatedat,
      contactid,
      salutation,
      firstname,
      lastname,   
      email,
      otheremail,
      inactive,
      unsubscribed,
      phone,
      mobile,
      owner_firstName,
      owner_lastName,
      owner_userId, 
      owner_email, 
      status_name,     
      statusid,
      company_name,
      companyid,
      office_name,
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
      updatedat as _airbyte_start_at,
      lag(updatedat) over (
        partition by contactid
        order by
            updatedat is null asc,
            updatedat desc,
            _airbyte_emitted_at desc
      ) as _airbyte_end_at,
      case when row_number() over (
        partition by contactid
        order by
            updatedat is null asc,
            updatedat desc,
            _airbyte_emitted_at desc
      ) = 1 then 1 else 0 end as _airbyte_active_row,
      _airbyte_ab_id,
      _airbyte_emitted_at,
      _airbyte_contacts_hashid
    from input_data
),
dedup_data as (
    select
        -- we need to ensure de-duplicated rows for merge/update queries
        -- additionally, we generate a unique key for the scd table
        row_number() over (
            partition by
                _airbyte_unique_key,
                _airbyte_start_at,
                _airbyte_emitted_at
            order by _airbyte_active_row desc, _airbyte_ab_id
        ) as _airbyte_row_num,
        {{ dbt_utils.surrogate_key([
          '_airbyte_unique_key',
          '_airbyte_start_at',
          '_airbyte_emitted_at'
        ]) }} as _airbyte_unique_key_scd,
        scd_data.*
    from scd_data
)
select
    _airbyte_unique_key,
    _airbyte_unique_key_scd,
    createdat,
    updatedat,
    contactid,
    salutation,
    firstname,
    lastname,   
    email,
    otheremail,
    inactive,
    unsubscribed,
    phone,
    mobile,
    owner_firstName,
    owner_lastName,
    owner_userId, 
    owner_email, 
    status_name,     
    statusid,
    company_name,
    companyid,
    office_name,
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
    _airbyte_start_at,
    _airbyte_end_at,
    _airbyte_active_row,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_contacts_hashid
from dedup_data where _airbyte_row_num = 1

