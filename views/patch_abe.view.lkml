view: patch_abe {
  sql_table_name: `ods.Patch_abe`
    ;;

  dimension: ca_net {
    type: number
    sql: ${TABLE}.CA_NET ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_MAGASIN ;;
  }

  dimension_group: dt_vente {
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
    sql: ${TABLE}.DT_VENTE ;;
  }

  dimension: id_magasin {
    type: number
    sql: ${TABLE}.ID_MAGASIN ;;
  }

  dimension_group: processing {
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
    sql: ${TABLE}.PROCESSING_DATE ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.QTITE ;;
  }

  dimension_group: send_patch {
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
    sql: ${TABLE}.SEND_PATCH_DATE ;;
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.STATUT ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
