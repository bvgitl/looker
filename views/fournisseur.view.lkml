view: fournisseur {
  sql_table_name: `ods.fournisseur`
    ;;

  dimension: cd_progest {
    type: string
    sql: ${TABLE}.CD_PROGEST ;;
  }

  dimension: cd_sdp {
    type: string
    sql: ${TABLE}.CD_SDP ;;
  }

  dimension: cd_xmag {
    type: string
    sql: ${TABLE}.CD_XMAG ;;
  }

  dimension: id_fourn {
    type: number
    sql: ${TABLE}.ID_FOURN ;;
  }

  dimension: nom_fourn {
    type: string
    sql: ${TABLE}.NOM_FOURN ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
