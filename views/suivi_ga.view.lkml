view: suivi_ga {
  sql_table_name: `bv-prod.looker_pg.suivi_ga`
    ;;

  dimension: _ca_indirect_ {
    type: number
    sql: ${TABLE}._CA_indirect_ ;;
    drill_fields: [sheet_client*]
  }

  dimension: _visites_en_magasin_ {
    type: number
    sql: ${TABLE}._Visites_en_magasin_ ;;
    drill_fields: [sheet_client*]
  }

  dimension: ca {
    type: number
    sql: ${TABLE}.CA ;;
    drill_fields: [sheet_client*]
  }

  dimension: conv__indirectes {
    type: number
    sql: ${TABLE}.Conv__indirectes ;;
    drill_fields: [sheet_client*]
  }

  dimension: conversions {
    type: number
    sql: ${TABLE}.Conversions ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: date_d_envoi {
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
    sql: ${TABLE}.Date_d_envoi ;;
    drill_fields: [sheet_client*]
  }

  dimension: nom_de_la_campagne {
    type: string
    sql: ${TABLE}.Nom_de_la_campagne ;;
    drill_fields: [sheet_client*]
  }

  dimension: pourcentage_nouvelles_sessions {
    type: string
    sql: ${TABLE}.Pourcentage_nouvelles_sessions ;;
    drill_fields: [sheet_client*]
  }

  dimension: session {
    type: number
    sql: ${TABLE}.Session ;;
    drill_fields: [sheet_client*]
  }

  dimension: taux_de_conversion {
    type: number
    sql: ${TABLE}.Taux_de_conversion ;;
    drill_fields: [sheet_client*]
  }

  dimension: taux_de_rebond {
    type: number
    sql: ${TABLE}.Tx_de_rebond ;;
    drill_fields: [sheet_client*]
  }

  dimension: volume_envoye {
    type: number
    sql: ${TABLE}.Volume_envoye ;;
    drill_fields: [sheet_client*]
  }

  measure: count {
    type: count
    drill_fields: [sheet_client*]
  }

  set: sheet_client {
    fields: [nom_de_la_campagne,volume_envoye,session,date_d_envoi_date,ca,conversions,taux_de_conversion,taux_de_rebond]
    }
}
