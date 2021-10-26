view: factu_campagne {
  sql_table_name: `bv-prod.looker_pg.factu_campagne`
    ;;

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
    drill_fields: [customer_id,date_creation_date,email,id_mag_rattachement,optin_email,type_client]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [camp_name,date_creation_date,email,id_mag_rattachement,optin_email,type_client]
  }

  dimension_group: date_creation {
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
    sql: ${TABLE}.date_creation ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: id_mag_rattachement {
    type: string
    sql: ${TABLE}.id_mag_rattachement ;;
    drill_fields: [customer_id,camp_name,date_creation_date,email,id_mag_rattachement,optin_email,type_client]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [customer_id,camp_name,date_creation_date,email,id_mag_rattachement,optin_email,type_client]
  }

  measure: count {
    type: count
    drill_fields: [camp_name]
  }
}
