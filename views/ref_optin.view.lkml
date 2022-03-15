view: ref_optin {
  sql_table_name: `bv-prod.looker_pg.ref_optin`
    ;;

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
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
    drill_fields: [sheet_client*]
  }


  dimension_group: d_unsub {
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
    sql: cast(${TABLE}.d_unsub_time as TIMESTAMP )  ;;
    drill_fields: [sheet_client*]
  }

  dimension: tranche_age {
    type:  string
    sql: ${TABLE}.Tranche_age ;;
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
    sql: cast( ${TABLE}.date_creation as TIMESTAMP ) ;;
    drill_fields: [sheet_client*]
  }

  dimension: date_creation_periode{
    case: {
      when: {
        sql:  ${date_creation_year} = 2019;;
        label: "2019"
      }
      when: {
        sql:  ${date_creation_year} = 2020;;
        label: "2020"
      }
      when: {
        sql:  ${date_creation_year} = 2021;;
        label: "2021"
      }
      # when: {
      #   sql:  ${date_creation_year} = 2022;;
      #   label: "2022"
      # }
      when: {
        sql: (extract(month from ${date_creation_date}) =  extract(month from date_sub(current_date( ) , interval 1 month) ))
          and (  ${date_creation_year} = extract(year from current_date() ) );;
        label: "Mois précédent"
      }
    }
    suggest_persist_for: "2 seconds"
  }



  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    drill_fields: [sheet_client*]
  }

  dimension: flag_click_12m_sans_activite {
    type: string
    sql: ${TABLE}.flag_click_12m_sans_activite ;;
  }

  dimension: flag_click_24m_sans_activite {
    type: string
    sql: ${TABLE}.flag_click_24m_sans_activite ;;
  }

  dimension: flag_click_36m_sans_activite {
    type: string
    sql: ${TABLE}.flag_click_36m_sans_activite ;;
  }

  dimension: flag_open_12m_sans_activite {
    type: string
    sql: ${TABLE}.flag_open_12m_sans_activite ;;
  }

  dimension: flag_open_24m_sans_activite {
    type: string
    sql: ${TABLE}.flag_open_24m_sans_activite ;;
  }

  dimension: flag_open_36m_sans_activite {
    type: string
    sql: ${TABLE}.flag_open_36m_sans_activite ;;
  }

  dimension: coord {
    type: location
    map_layer_name: my_map
    sql_latitude: ${TABLE}.Latitude ;;
    sql_longitude: ${TABLE}.Longitude ;;
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
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
  }

  dimension: portable_ok {
    type: string
    sql: ${TABLE}.portable_ok ;;
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

  measure: Volume {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: ${TABLE}.customer_id ;;
  }

  set: sheet_client {
    fields: [customer_id,type_client,email,civilite,optin_sms,optin_email,date_creation_date, d_unsub_date,cd_magasin,format,animateur,tranche_age,region]
  }
}
