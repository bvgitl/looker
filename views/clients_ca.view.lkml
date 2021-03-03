view: clients_ca {
  sql_table_name: `ods.clients_ca`
    ;;

  dimension: ca_cumul_ht {
    type: number
    sql: ${TABLE}.ca_cumul_ht ;;
  }

  dimension: ca_orig {
    type: string
    sql: ${TABLE}.ca_orig ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension_group: date_dern_achat {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_dern_achat ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: mag_code {
    type: string
    sql: ${TABLE}.mag_code ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.nom ;;
  }

  dimension: periode {
    type: string
    sql: ${TABLE}.periode ;;
  }

  dimension: prenom {
    type: string
    sql: ${TABLE}.prenom ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: tel_port {
    type: string
    sql: ${TABLE}.tel_port ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
