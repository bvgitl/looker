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
    sql: cast(${TABLE}.date_creation as TIMESTAMP) ;;
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

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
    drill_fields: [sheet_client*]
  }


 filter: date_test2 {
  type: string
  default_value: "default value !! "
  suggestions: ["30 jours avant","2 jours avant"]
  suggest_dimension: date_creation_date
  sql: ${TABLE}.date_creation ;;
  suggest_persist_for: "1 second"




 }

  dimension: period_comparison {
    case: {
      when: {
        sql: date_diff (current_date(), ${date_creation_date}, month ) = 2;;
          label: "2 denier mois"
            }
      else: "unknown"
          }
    suggest_persist_for: "2 seconds"
}


  dimension: coord {
    type: location
    map_layer_name: my_map
    sql_latitude: ${TABLE}.Latitude ;;
    sql_longitude: ${TABLE}.Longitude ;;

  }

  dimension: latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
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

  }

  dimension: portable_ok {
    type: string
    sql: ${TABLE}.portable_ok ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;

  }

  dimension: tranche_age {
    type:  string
    sql: ${TABLE}.Tranche_age ;;
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
    suggest_persist_for: "2 seconds"
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.Ville ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: date_dernier_achat {
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
    sql: cast(${TABLE}.date_dernier_achat as TIMESTAMP) ;;
    drill_fields: [sheet_client*]
  }

  dimension: adresse {
    type: string
    sql: ${TABLE}.adresse ;;
    drill_fields: [sheet_client*]
  }

  measure: count {
    type: count
    drill_fields: [sheet_client*]
  }

  measure: Volume {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: ${TABLE}.customer_id ;;
  }


  set: sheet_client {
    fields: [customer_id,email,optin_email,portable_ok, optin_sms,type_client,date_creation_date,date_dernier_achat_date, anciennete_mois,civilite,adresse,cd_magasin,format, animateur,tranche_age,region]
  }
}
