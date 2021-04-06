view: google_sheet {
  sql_table_name: `bv-prod.Matillion_Perm_Table.GOOGLE_SHEET`
    ;;

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.CA_HT ;;
  }

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_SITE_EXT ;;
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
    type: string
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

  dimension: qtite {
    type: number
    sql: ${TABLE}.QTITE ;;
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

  measure: Nb_de_lignes {
    type: count
  }

  measure: sum_ca_ht {
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
  }
}
