view: ref_optin {
  sql_table_name: `bv-prod.looker_pg.ref_optin`
    ;;

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
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

  dimension: flag_desabo {
    type: string
    sql: ${TABLE}.flag_desabo ;;
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

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
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
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.Ville ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}