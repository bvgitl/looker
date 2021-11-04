view: factu_campagne {
  sql_table_name: `bv-prod.looker_pg.factu_campagne`
    ;;

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
    drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
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
    drill_fields: [sheet_client*]
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
    drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: [sheet_client*]
  }

  set: sheet_client {
    fields: [customer_id,type_client,dte_camp_date,camp_name,email,store_code,optin_email, count]
    }
}
