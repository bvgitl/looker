view: Factu_campagne {
  sql_table_name: `bv-prod.looker_pg.factu_campagne`
    ;;

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
    drill_fields: [sheet_factu*]
    suggest_persist_for: "2 seconds"
  }

  dimension: camp_type {
    type: string
    sql: ${TABLE}.camp_type ;;
    drill_fields: [sheet_factu*]
    suggest_persist_for: "2 seconds"
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: dte_camp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.dte_camp ;;
    drill_fields: [sheet_factu*]
  }

  dimension: date_camp_periode{
    case: {
      when: {
        sql:  ${dte_camp_year} = 2019;;
        label: "2019"
      }
      when: {
        sql:  ${dte_camp_year}  = 2020;;
        label: "2020"
      }
      when: {
        sql:  ${dte_camp_year}  = 2021;;
        label: "2021"
      }
      # when: {
      #   sql:  ${date_creation_year} = 2022;;
      #   label: "2022"
      # }
      when: {
        sql: (extract(month from ${dte_camp_date} ) =  extract(month from date_sub(current_date( ) , interval 1 month) ))
          and (  ${dte_camp_year}  = extract(year from current_date() ) );;
        label: "Mois précédent"
      }
    }
    suggest_persist_for: "2 seconds"
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: store_code {
    type: string
    sql: ${TABLE}.store_code ;;
    drill_fields: [sheet_factu*]
    suggest_persist_for: "2 seconds"
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: [sheet_factu*]
  }

  set: sheet_factu {
    fields: [camp_name,customer_id,dte_camp_date,email,optin_email,store_code,type_client,count]
  }
}
