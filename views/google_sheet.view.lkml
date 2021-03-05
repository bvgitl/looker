view: google_sheet {
  sql_table_name: `bv-prod.ods.google_sheet`
    ;;

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.CA_HT ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_MAGASIN ;;
  }

  dimension: cd_pays {
    type: string
    sql: ${TABLE}.CD_PAYS ;;
  }

  dimension_group: date_ouv {
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
    sql: ${TABLE}.DATE_OUV ;;
  }

  dimension_group: dte_vente {
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
    sql: ${TABLE}.DTE_VENTE ;;
  }

  dimension: id_article {
    type: number
    sql: ${TABLE}.ID_ARTICLE ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.MARGE_BRUTE ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.NB_TICKET ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.QTITE ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.STATUT_ARTICLE ;;
  }

  dimension: surf_vte {
    type: number
    sql: ${TABLE}.SURF_VTE ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.TYP_ARTICLE ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.TYP_VENTE ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.VAL_ACHAT_GBL ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_ca_ht {
    type: sum
    sql: ${ca_ht} ;;
  }
}
