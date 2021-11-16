view: test_factu_campagne {
  sql_table_name: `bv-prod.looker_pg.test_factu_campagne`
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
    #drill_fields: [sheet_client*]
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    #drill_fields: [customer_id,camp_name,date_creation_date,email,id_mag_rattachement,optin_email,type_client]

  }

  dimension: id_mag_rattachement {
    type: string
    sql: ${TABLE}.id_mag_rattachement ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
    #drill_fields: [customer_id,camp_name,date_creation_date,email,id_mag_rattachement,optin_email,type_client]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_client*]
  }

  measure: count {
    type: count
    drill_fields: [camp_name]
  }
  set: sheet_client {
    fields: [customer_id,type_client,date_creation_date,camp_name,email,id_mag_rattachement,optin_email, count]
}
}
