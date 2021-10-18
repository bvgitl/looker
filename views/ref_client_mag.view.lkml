view: ref_client_mag {
  sql_table_name: `bv-prod.looker_pg.ref_client_mag`
    ;;

  dimension: anciennete_mois {
    type: number
    sql: ${TABLE}.anciennete_mois ;;
    drill_fields: [sheet_client*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    drill_fields: [sheet_client*]
  }

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
    drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    primary_key: yes
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
    drill_fields: [sheet_client*]
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    drill_fields: [sheet_client*]
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
    drill_fields: [sheet_client*]
  }

  dimension: latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
    drill_fields: [sheet_client*]
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
    drill_fields: [sheet_client*]
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
    drill_fields: [sheet_client*]
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
    drill_fields: [sheet_client*]
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_client*]
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.Ville ;;
    drill_fields: [sheet_client*]
  }

  measure: count {
    type: count
    drill_fields: [sheet_client*]
  }

  set: sheet_client {
    fields: [customer_id,type_client,date_creation_date,anciennete_mois,civilite,cd_magasin,format]
  }
}
