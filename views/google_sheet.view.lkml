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

  dimension: id_tf_vte {
    type: number
    primary_key: yes
    sql: ${TABLE}.ID_TF_VTE ;;
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
    label: "nbre de lignes corrigées"
    type: count
    drill_fields: [details*]
  }

  measure: sum_ca_ht {
    label: "CA manquant"
    type: sum
    drill_fields: [details*]
  }

  dimension: tot_tx_marge_brute {
    type: number
    value_format_name: percent_2
    sql:  1.0 * ${marge_brute}/NULLIF(${ca_ht},0) ;;
  }

  measure: count_id_tf_vente {
    label: "nbre de lignes ca corrigé"
    type: count
    filters: [ca_ht: "<0 AND >0"]
    drill_fields: [details*]
  }

  measure: count_CD_MAG_negatif {
    label: "nbre de lignes marge corrigé"
    type: count
    filters: [marge_brute: "NULL"]
    drill_fields: [details*]
  }

  measure: count_article_marge_errone {
    label: "nbre de lignes tx marge corrigé"
    type: count
    filters: [tot_tx_marge_brute: "<0 AND >0"]
    drill_fields: [details*]
  }

  set: details {
    fields: [
      cd_magasin,
      dte_vente_date,
      ca_ht,
      marge_brute
    ]
  }
}
