{%- macro create_surrogate_key(fields_list) -%}

    {%- if not fields_list or not fields_list|length -%}
        {%- do exceptions.raise('The create_surrogate_key macro requires at least one field in the list.') -%}
    {%- endif -%}

    {# Transform each field: apply coalesce and cast to string #}
    {%- set transformed_fields = [] -%}
    {%- for field in fields_list -%}
        {%- set _ = transformed_fields.append("coalesce(cast(" ~ field ~ " as string), '')") -%}
    {%- endfor -%}

    {# Combine the transformed fields into a single string with separator '-' #}
    {%- set combined_key = transformed_fields | join(" || '-' || ") -%}

    -- Generate the surrogate key using HASH and ensure it's positive
    abs(hash({{ combined_key }}))

{%- endmacro -%}