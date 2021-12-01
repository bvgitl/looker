view: suivi_ga {
  sql_table_name: `bv-prod.looker_pg.suivi_ga`
    ;;

  dimension: _ca_indirect_ {
    type: number
    sql: ${TABLE}._CA_indirect_ ;;
  }

  dimension: _visites_en_magasin_ {
    type: number
    sql: ${TABLE}._Visites_en_magasin_ ;;
  }

  dimension: ca {
    type: number
    sql: ${TABLE}.CA ;;
  }

  dimension: conv__indirectes {
    type: number
    sql: ${TABLE}.Conv__indirectes ;;
  }

  dimension: conversions {
    type: number
    sql: ${TABLE}.Conversions ;;
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
  }

  dimension: nom_de_la_campagne {
    type: string
    sql: ${TABLE}.Nom_de_la_campagne ;;
  }

  dimension: pourcentage_nouvelles_sessions {
    type: string
    sql: ${TABLE}.Pourcentage_nouvelles_sessions ;;
  }

  dimension: session {
    type: number
    sql: ${TABLE}.Session ;;
  }

  dimension: taux_de_conversion {
    type: number
    sql: ${TABLE}.Taux_de_conversion ;;
  }

  dimension: taux_de_rebond {
    type: number
    sql: ${TABLE}.Tx_de_rebond ;;
  }

  dimension: volume_envoye {
    type: number
    sql: ${TABLE}.Volume_envoye ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
