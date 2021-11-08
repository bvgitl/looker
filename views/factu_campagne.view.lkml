view: Factu_campagne {
  sql_table_name: `bv-prod.looker_pg.factu_campagne`
    ;;

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
    drill_fields: [sheet_factu*]
  }

  dimension: camp_type {
    type: string
    sql: ${TABLE}.camp_type ;;
    drill_fields: [sheet_factu*]
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
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: [camp_name]
  }

  set: sheet_factu {
    fields: [camp_name,camp_type,count,customer_id,dte_camp_date,email,optin_email,store_code,type_client, count]
  }
}
